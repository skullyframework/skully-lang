<?php
namespace SkullyLang\Helpers;

class SiteLanguagesHelper {
    protected $config = array(
        'langDir' => '/',
        'languages' => array(
            'en' => array('value' => 'English', 'code' => 'en'),
            'id' => array('value' => 'Indonesian', 'code' => 'id')
        ),
        'timezone' => 'Asia/Jakarta'
    );
    protected $mode;
    protected $activeLanguage;

    public function setMode($mode)
    {
        $this->mode = $mode;
    }

    public function getMode()
    {
        return $this->mode;
    }

    public function setConfig($name_or_array, $value = null)
    {
        if (is_array($name_or_array)) {
            foreach($name_or_array as $key => $configItem) {
                $this->setConfig($key, $configItem);
            }
        }
        else {
            $this->config[$name_or_array] = $value;
        }
        if (substr($this->config['langDir'],-1,1) !== DIRECTORY_SEPARATOR) {
            $this->config['langDir']=$this->config['langDir'].DIRECTORY_SEPARATOR;
        }
    }

    public function getConfig($name)
    {
        return $this->config[$name];
    }

    public function setLanguage($lang)
    {
        $this->activeLanguage = $lang;
    }

    public function getLanguage()
    {
        return $this->activeLanguage;
    }

    private function sanitizePath($path) {
        // Removing '/' suffix and prefix.
        if (substr($path,-1,1) == DIRECTORY_SEPARATOR) {
            $path=substr($path,0,-1);
        }
        if (substr($path,0,1) == DIRECTORY_SEPARATOR) {
            $path = substr($path, 1);
        }
        return $path;
    }

    public function prepareMode($path) {
        $path = $this->sanitizePath($path);
        if (is_dir($this->getCompletePath($path))) {
            $this->setMode('dir');
        }
        else {
            if (file_exists($this->getCompletePath($path))) {
                $this->setMode('file');
            }
            else {
                throw new \Exception('File not found');
            }
        }
    }

    public function getCompletePath($path)
    {
        $path = $this->sanitizePath($path);
        return $this->getConfig('langDir').$this->getLanguage().DIRECTORY_SEPARATOR.$path;
    }

    /**
     * @param string $path
     * @return array
     *      Get all directories / files ("items") of given path (path could be dir or file).
     * An item follows this format:
     * array(
     * 'type' => ['dir' or 'file' or 'entry'],
     * 'name' => ['admin' or '_adminLang.json' or 'title'],
     * 'value' => [only give a value when type is 'entry'],
     * 'path' => [path to dir or file, entry does not need this],
     * 'UpdatedAt' => [updated at in timestamp]
     * )
    path is 'stuff/morestuff' for dir, or '[language]/stuff/morestuff/file.json' for file.
     */
    public function getItems($path)
    {
        $path = $this->sanitizePath($path);
        $items = array();
        // If path is dir, glob it.
        if (is_dir($this->getCompletePath($path))) {
            $filepaths = glob($this->getCompletePath($path).DIRECTORY_SEPARATOR.'*');
            $timeAgo= new \TimeAgo($this->getConfig('timezone'));
            $dirs = [];
            $files = [];
            foreach($filepaths as $filepath) {
                $timestring = date('Y/m/d h:m:i', filemtime($filepath));
                $timeAgoString = $timeAgo->inWords($timestring, "now");
                $name = substr($filepath,strrpos($filepath, DIRECTORY_SEPARATOR)+1);

                if (is_dir($filepath)) {
                    $dirs []= array(
                        'type' => 'dir',
                        'name' => $name,
                        'path' => $path.DIRECTORY_SEPARATOR.$name,
                        'updatedAt' => $timeAgoString . ' ago'
                    );
                }
                elseif(is_file($filepath)) {
                    $files []= array(
                        'type' => 'file',
                        'name' => $name,
                        'path' => $path.DIRECTORY_SEPARATOR.$name,
                        'updatedAt' => $timeAgoString . ' ago'
                    );
                }
            }
            $items = array_merge($dirs, $files);
        }
        else {
            if (is_file($this->getCompletePath($path))) {
                $entries = $this->readFile($this->getCompletePath($path));
                ksort($entries);
                foreach($entries as $key=>$value) {
                    $items []= array(
                        'type' => 'entry',
                        'name' => $key,
                        'value' => $value,
                        'path' => $path
                    );
                }
            }
        }
        return $items;
    }

    private function readFile($completePath = '') {
        $entries = array();
        if (file_exists($completePath)) {
            $entriesJson = file_get_contents($completePath);
            $entries = json_decode($entriesJson, true);

            if (!is_array($entries)) {
                throw new \Exception('invalid json format. Check this file: ' .$completePath);
            }
        }
        return $entries;
    }

    // Array of array('name' => string, 'path' => string, 'active' => boolean)
    public function getBreadcrumbs($path = '', $name = '') {
        $path = $this->sanitizePath($path);
        $breadcrumbs = array(array('name' => 'Root', 'path' => '/'));
        $path_r = explode(DIRECTORY_SEPARATOR, $path);
        $pathSoFar = '';
        if (!empty($name)) {
            $entry = $this->getItem($path, $name);
        }
        foreach($path_r as $id => $item) {
            if (!empty($item)) {
                $pathSoFar .= '/'.$item;
                if (($id === count($path_r)-1) && empty($entry)) {
                    $pathSoFar = null;
                }
                $breadcrumbs []= array('name' => $item, 'path' => $pathSoFar);
            }
        }
        if (!empty($name) && !empty($entry)) {
            $breadcrumbs []= array('name' => $name, 'path' => null);
        }
        return $breadcrumbs;
    }

    public function getItem($path = '', $name = '') {
        $item = array();
        $entries = $this->readFile($this->getCompletePath($path));
        if (!array_key_exists($name, $entries)) {
            return null;
        }
        else {
            if (!empty($entries)) {
                $item['name'] = $name;
                $item['value'] = $entries[$name];
                $item['path'] = $path;
            }
        }
        return $item;
    }

    function updateItem($path, $oldName, $newName, $newValue)
    {
        if (!is_writable($this->getCompletePath($path))) {
            throw new \Exception('File not writable: '.$path);
        }
        else {
            $entries = $this->readFile($this->getCompletePath($path));
            if (empty($entries)) {
                $entries = array();
            }
            if ($oldName !== $newName && array_key_exists($newName, $entries)) {
                throw new \Exception('Name already used. Please use another.');
            }
            elseif (empty($newName)) {
                throw new \Exception('Name cannot be empty.');
            }
            else {
                unset($entries[$oldName]);
                $entries[$newName] = $newValue;
                file_put_contents($this->getCompletePath($path), json_encode($entries));
            }
        }
    }
    function deleteItem($path, $name) {
        if (!is_writable($this->getCompletePath($path))) {
            throw new \Exception('File not writable: '.$path);
        }
        else {
            $entries = $this->readFile($this->getCompletePath($path));
            if (empty($entries)) {
                $entries = array();
            }
            unset($entries[$name]);
            file_put_contents($this->getCompletePath($path), json_encode($entries));
        }
    }

    public static function isHtml($string){
        preg_match("/<\/?\w+((\s+\w+(\s*=\s*(?:\".*?\"|'.*?'|[^'\">\s]+))?)+\s*|\s*)\/?>/",$string, $matches);
        if(count($matches)==0){
            return FALSE;
        }else{
            return TRUE;
        }
    }
}