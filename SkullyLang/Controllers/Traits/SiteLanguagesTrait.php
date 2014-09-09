<?php
namespace SkullyLang\Controllers\Traits;

use App\Helpers\HtmlHelper;
use Skully\App\Helpers\FileHelper;
use SkullyLang\Helpers\SiteLanguagesHelper;

/**
 * Class SiteLanguagesTrait
 * @package SkullyLang\Controllers\Traits
 */
trait SiteLanguagesTrait {
    protected $indexTpl = '/skullyLang/siteLanguages/_index';
    protected $fileNotFoundTpl = '/skullyLang/siteLanguages/_fileNotFound';
    protected $itemNotFoundTpl = '/skullyLang/siteLanguages/_itemNotFound';
    protected $editTpl = '/skullyLang/siteLanguages/_edit';
    protected $deleteTpl = '/skullyLang/siteLanguages/_delete';
    protected $indexPath = 'admin/siteLanguages/index';
    protected $editPath = 'admin/siteLanguages/edit';
    protected $addPath = 'admin/siteLanguages/add';
    protected $deletePath = 'admin/siteLanguages/delete';
    protected $createPath = 'admin/siteLanguages/create';
    protected $updatePath = 'admin/siteLanguages/update';
    protected $destroyPath = 'admin/siteLanguages/destroy';

    protected function setupHelper()
    {
        $helper = new SiteLanguagesHelper();
        $helper->setConfig(array(
            'langDir' => $this->app->getTheme()->getAppPath('languages'.DIRECTORY_SEPARATOR),
            'languages' => $this->app->config('languages'),
            'timezone' => $this->app->config('timezone')
        ));
        $l = $this->getParam('l');
        if (!empty($l)) {
            $helper->setLanguage($this->getParam('l'));
        }
        else {
            $helper->setLanguage($this->app->config('language'));
        }
        return $helper;
    }
    public function index()
    {
        $this->assignPaths();
        $helper = $this->setupHelper();
        try {
            $helper->prepareMode($this->getParam('p'));
            $this->assignItems($helper);
            $this->render($this->indexTpl);
        }
        catch (\Exception $e) {
            $this->showMessage($e->getMessage());
            $this->render($this->fileNotFoundTpl);
        }
    }

    private function assignPaths()
    {
        $this->app->getTemplateEngine()->assign(array(
            'indexPath' => $this->indexPath,
            'addPath' => $this->addPath,
            'editPath' => $this->editPath,
            'deletePath' => $this->deletePath,
            'destroyPath' => $this->destroyPath
        ));
    }

    private function assignItems($helper)
    {
        $items = $helper->getItems($this->getParam('p'));

        $this->app->getTemplateEngine()->assign(array(
            'mode' => $helper->getMode(),
            'items' => $items,
            'breadcrumbs' => array(),
            'siteLanguagesBreadcrumbs' => $helper->getBreadcrumbs($this->getParam('p'), $this->getParam('id')),
            'languages' => $this->app->config('languages'),
            'defaultLanguage' => $this->app->config('language')
        ));
    }

    public function add()
    {
        $this->app->getTemplateEngine()->assign('formPath', $this->createPath);
        $this->form();
    }

    protected function form()
    {
        $this->assignPaths();
        $helper = $this->setupHelper();
        $helper->setMode('item');
        try {
            $this->assignItems($helper);
            $item = $helper->getItem($this->getParam('p'), $this->getParam('id'));
            if (HtmlHelper::isHtml($item['value'])) {
                $this->app->getTemplateEngine()->assign('isHtml', true);
            }
            $this->app->getTemplateEngine()->assign('item', $item);
            $this->render($this->editTpl);
        }
        catch (\Exception $e){
            $this->showMessage($e->getMessage());
            if (file_exists($helper->getCompletePath($this->getParam('p')))) {
                $this->render($this->itemNotFoundTpl);
            }
            else {
                $this->render($this->fileNotFoundTpl);
            }
        }
    }

    public function edit()
    {
        $this->app->getTemplateEngine()->assign('formPath', $this->updatePath);
        $this->form();
    }

    public function create()
    {
        $this->processForm($this->createPath);
    }

    public function update()
    {
        $this->processForm($this->editPath);
    }

    protected function processForm($failurePath)
    {
        $helper = $this->setupHelper();
        $helper->setMode('item');
        if (!empty($_POST)) {
            $itemParams = $this->getParam('item');
            try {
                $this->assignItems($helper);
                $helper->updateItem($this->getParam('p'), $this->getParam('id'), $itemParams['name'], $itemParams['value']);
                FileHelper::removeFolder($this->app->config('basePath').'App/smarty/cache');
                FileHelper::removeFolder($this->app->config('basePath').'App/smarty/templates_c');
                $this->app->redirect($this->editPath, array('p' => $this->getParam('p'), 'id' => $itemParams['name'], 'l' => $this->getParam('l')));
            }
            catch (\Exception $e) {
                if (file_exists($this->getCompletePath($this->getParam('p')))) {
                    $this->render($this->itemNotFoundTpl);
                }
                else {
                    $this->render($this->fileNotFoundTpl);
                }
            }
        }
        else {
            $this->app->redirect($failurePath, array('p' => $this->getParam('p'), 'id' => $this->getParam('id'), 'l' => $this->getParam('l')));
        }
    }

    public function delete()
    {
        $this->assignPaths();
        $this->render($this->deleteTpl);
    }

    public function destroy()
    {
        $helper = $this->setupHelper();
        $helper->setMode('item');
        if (!empty($_POST)) {
            try {
                $this->assignItems($helper);
                $helper->deleteItem($this->getParam('p'), $this->getParam('id'));
                FileHelper::removeFolder($this->app->config('basePath').'App/smarty/cache');
                FileHelper::removeFolder($this->app->config('basePath').'App/smarty/templates_c');
                $this->setMessage("Item ".$this->getParam('id')." deleted", 'message');
            }
            catch (\Exception $e) {
                if (file_exists($this->getCompletePath($this->getParam('p')))) {
                    $this->setMessage("Item not found", 'error');
                }
                else {
                    $this->setMessage("File not found", 'error');
                }
            }
        }
        else {
            $this->setMessage("Cannot access this page directly", 'error');
        }
        echo (json_encode(array(
            'redirect' => $this->app->getRouter()->getUrl($this->indexPath, array('p' => $this->getParam('p'), 'id' => $this->getParam('id'), 'l' => $this->getParam('l')))
        )));
    }
}