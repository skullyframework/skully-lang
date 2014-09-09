<?php
namespace SkullyLang;

/**
 * Class SkullyLangTraits
 * @package App
 * Trait to be used at App\Application
 */
trait SkullyLangTrait {
    protected function addLangTemplateDir()
    {
        $this->getTheme()->setDir(realpath(__DIR__.'/../public'), 'skully-lang');
    }
} 