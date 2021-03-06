{nocache}
    {form action={url path=$_path.route|cat:'/'|cat:$_path.action} method='GET'}
        <input type="hidden" name="p" value="{$params['p']}"/>
        <input type="hidden" name="id" value="{$params['id']}"/>
        <select id="table-language-selector" name="l" class="select">
            {foreach $languages as $languageSelection}
                <option value="{$languageSelection.code}" {if $params['l'] === $languageSelection.code}selected{/if}>{$languageSelection.value}{if $languageSelection.code == $defaultLanguage} (default){/if}</option>
            {/foreach}
        </select>
    {/form}
    <ul class="breadcrumbs inline">
        {foreach $siteLanguagesBreadcrumbs as $crumb}
            {if empty($crumb.path)}
                <li><span>{$crumb.name}</span></li>
            {else}
                <li><a href="{url path={$indexPath} p={$crumb.path} l={$params['l']}}">{$crumb.name}</a></li>
            {/if}
        {/foreach}
    </ul>
    <div class="TAR">
        {if ($mode === 'dir')}
            {*<a class="btn" id="btn-add-file">Add File</a>*}
            {*<a class="btn" id="btn-add-dir">Add Directory</a>*}
            {*<a class="btn" id="btn-edit">Edit</a>*}
        {elseif ($mode === 'file')}
            <a class="btn" href="{url path=$addPath p={$params.p} l={$params['l']}}">Add Item</a>
            {*<a class="btn" href="#" id="btn-edit">Edit</a>*}
        {elseif ($mode === 'item') && $_path.action == 'edit' || $_path.action == 'update'}
            <a class="btn" href="{url path=$addPath p={$params.p} l={$params['l']}}">Add Item</a>
            <a class="btn" href="{url path=$deletePath p={$params.p} l={$params['l']} id={$params['id']}}" id="btn-delete-this-item" data-toggle="dialog">Delete Item</a>
        {/if}
    </div>
{/nocache}