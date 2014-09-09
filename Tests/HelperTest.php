<?php
namespace Tests;
use SkullyLang\Helpers\SiteLanguagesHelper;
date_default_timezone_set('Asia/Jakarta');

/**
 * Description: Tests for Lang Editor. To run within SkullyMVC,
 * browse to tests/ directory, then run: ./phpunit.phar /pathToLibrary/langEditor/tests/unit/TestName.php
 */
class HelperTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @var $helper SiteLanguagesHelper
     */
    protected $helper;

    public function setUp() {
        $this->helper = new SiteLanguagesHelper();
        $this->helper->setConfig(
            array(
                'langDir' => realpath(__DIR__).DIRECTORY_SEPARATOR.'app'.DIRECTORY_SEPARATOR.'public'.DIRECTORY_SEPARATOR.'default'.DIRECTORY_SEPARATOR.'SkullyLangTestApp'.DIRECTORY_SEPARATOR.'languages'.DIRECTORY_SEPARATOR,
                'languages' => array(
                    'en' => array('value' => 'English', 'code' => 'en'),
                    'id' => array('value' => 'Indonesian', 'code' => 'id'),
                    'tw' => array('value' => 'Chinese (TW)', 'code' => 'tw')
                )
            )
        );
        $json = json_encode(array(
            'title' => 'Detil Produk',
            'content' => 'Konten'
        ));
        file_put_contents(realpath(__DIR__).DIRECTORY_SEPARATOR.'app'.DIRECTORY_SEPARATOR.'public'.DIRECTORY_SEPARATOR.'default'.DIRECTORY_SEPARATOR.'SkullyLangTestApp'.DIRECTORY_SEPARATOR.'languages'.DIRECTORY_SEPARATOR.'id'.DIRECTORY_SEPARATOR.'products'.DIRECTORY_SEPARATOR.'detail'.DIRECTORY_SEPARATOR.'_detailLang.json', $json);

    }

    public function tearDown() {
        $this->helper = null;
    }

    public function testGetDirItems() {
        $this->helper->setLanguage('en');
        $items = $this->helper->getItems('products');
        $this->assertEquals(8, count($items));
        $this->assertEquals('detail', $items[0]['name']);
        $this->assertEquals('_productsLang.json', $items[1]['name']);
        $this->assertEquals('a.json', $items[2]['name']);
        $this->assertEquals('b.json', $items[3]['name']);
        $this->assertEquals('c.json', $items[4]['name']);
        $this->assertEquals('d.json', $items[5]['name']);
        $this->assertEquals('e.json', $items[6]['name']);
        $this->assertEquals('indexLang.json', $items[7]['name']);
        $this->helper->prepareMode('products');
        $this->assertEquals('dir', $this->helper->getMode());
    }

    public function testGetFileItems() {
        $this->helper->setLanguage('en');
        $items = $this->helper->getItems('products/detail/_detailLang.json');
        $this->assertEquals('Content', $items[0]['value']);
        $this->assertEquals('content', $items[0]['name']);
        $this->helper->prepareMode('products/detail/_detailLang.json');
        $this->assertEquals('file', $this->helper->getMode());
    }

    public function testGetItem() {
        $this->helper->setLanguage('id');
        $item = $this->helper->getItem('products/detail/_detailLang.json', 'title');
        $this->assertEquals('title', $item['name']);
        $this->assertEquals('Detil Produk', $item['value']);
    }

    public function testGetBreadcrumbs() {
        $crumbs = $this->helper->getBreadcrumbs('products/detail/_detailLang.json', 'title');
        $this->assertEquals('/', $crumbs[0]['path']);
        $this->assertEquals('/products', $crumbs[1]['path']);
        $this->assertEquals('/products/detail', $crumbs[2]['path']);
        $this->assertEquals('/products/detail/_detailLang.json', $crumbs[3]['path']);
        $this->assertEquals(null, $crumbs[4]['path']);
    }

    /**
     * @expectedException \Exception
     */
    public function testUpdateItemFailWhenNameAlreadyUsed() {
        $this->helper->setLanguage('id');
        $this->helper->updateItem('products/detail/_detailLang.json', 'title', 'content', 'titletocontent');
    }

    /**
     * @expectedException \Exception
     */
    public function testUpdateItemFailWhenEmptyName() {
        $this->helper->setLanguage('id');
        $this->helper->updateItem('products/detail/_detailLang.json', 'title', '', 'titletocontent');
    }

    public function testUpdateItemSuccess() {
        $this->helper->setLanguage('id');
        $this->helper->updateItem('products/detail/_detailLang.json', 'content', 'content2', 'konten kedua');
        $item = $this->helper->getItem('products/detail/_detailLang.json', 'content2');
        $this->assertEquals($item['name'], 'content2');
        $this->assertEquals($item['value'], 'konten kedua');
    }

    public function testCreateAndDeleteItem() {
        $this->helper->setLanguage('id');
        $this->helper->updateItem('products/detail/_detailLang.json', '', 'new', 'konten baru');
        $item = $this->helper->getItem('products/detail/_detailLang.json', 'new');
        $this->assertEquals($item['name'], 'new');
        $this->assertEquals($item['value'], 'konten baru');
        $this->helper->deleteItem('products/detail/_detailLang.json', 'new');
        $item = $this->helper->getItem('products/detail/_detailLang.json', 'new');
        $this->assertEmpty($item);
    }
}