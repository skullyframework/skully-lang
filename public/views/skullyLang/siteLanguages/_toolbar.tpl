{nocache}
    <ul class="breadcrumb">
        {foreach $siteLanguagesBreadcrumbs as $crumb}
            {if empty($crumb.path)}
                {if $crumb.name != "/"}
                    <li><p>{$crumb.name}</p></li>
                {/if}
            {else}
                <li><a href="{url path={$indexPath} p={$crumb.path} l={$params['l']}}">{$crumb.name}</a></li>
            {/if}
        {/foreach}
    </ul>

    <div class="row">
        <div class="col-sm-8">
            {form action={url path=$_path.route|cat:'/'|cat:$_path.action} method='GET' style="display:inline-block;"}
                <input type="hidden" name="p" value="{$params['p']}"/>
                <input type="hidden" name="id" value="{$params['id']}"/>
                <select id="table-language-selector" name="l" class="cs-select cs-skin-slide" data-init-plugin="cs-select">
                    {foreach $languages as $languageSelection}
                        <option value="{$languageSelection.code}" {if $params['l'] === $languageSelection.code}selected{/if}>{$languageSelection.value}{if $languageSelection.code == $defaultLanguage} (default){/if}</option>
                    {/foreach}
                </select>
            {/form}
        </div>
        <div class="col-sm-4 text-right">
            {if ($mode === 'dir')}
                {*<a class="btn" id="btn-add-file">Add File</a>*}
                {*<a class="btn" id="btn-add-dir">Add Directory</a>*}
                {*<a class="btn" id="btn-edit">Edit</a>*}
            {elseif ($mode === 'file')}
                <a class="btn btn-primary" href="{url path=$addPath p={$params.p} l={$params['l']}}"><i class="fa fa-plus m-r-15"></i>Add Item</a>
                {*<a class="btn" href="#" id="btn-edit">Edit</a>*}
            {elseif ($mode === 'item') && $_path.action == 'edit' || $_path.action == 'update'}
                <a class="btn btn-primary" href="{url path=$addPath p={$params.p} l={$params['l']}}"><i class="fa fa-plus m-r-15"></i>Add Item</a>
                <a class="btn btn-danger" href="{url path=$deletePath p={$params.p} l={$params['l']} id={$params['id']}}" id="btn-delete-this-item" data-toggle="dialog"><i class="fa fa-trash m-r-15"></i>Delete Item</a>
            {/if}
        </div>
    </div>
{/nocache}