{extends file='admin/wrappers/_main.tpl'}
{block name='content'}
    {nocache}
        <div class="panel panel-transparent">
            <div class="panel-heading">
                <h2 class="text-primary bold"><i class="fa fa-bookmark m-r-15"></i>Site Language Manager</h2>
                <div class="clearfix"></div>
            </div>

            <div class="panel-body">
                <div class="toolbar m-b-15">
                    {include file='skullyLang/siteLanguages/_toolbar.tpl'}
                </div>
                {form class="validate" method="POST" action="{url path=$formPath}"}

                    <div class="affix-wrapper">
                        <nav class="affix-top">
                            <div class="panel panel-default">
                                <div class="panel-body ">
                                    <div class="row">
                                        <div class="col-sm-6">

                                        </div>
                                        <div class="col-sm-6 text-right">

                                            <button class="btn btn-primary" id="submitForm" type="submit"><i class="pg-save m-r-10"></i>Save Changes</button>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </nav>
                    </div>

                    {*<div class="block-fluid">*}
                        {include file='admin/widgets/_alerts.tpl' }
                        <div class="row">
                            <div class="col-sm-12">
                                <input name="p" type="hidden" value="{$params.p}" />
                                <input name="id" type="hidden" value="{$params.id}" />
                                <input name="l" type="hidden" value="{$params.l}" />
                                <h4>{if $_path.action == 'edit' || $_path.action == 'update'}Edit {$item.name}{else}New Item{/if}</h4>
                            </div>
                        </div>
                        <div class="form-group required">
                            <label for="item_name">{if $_path.action == 'edit' || $_path.action == 'update'}{lang value="Change Name"}{else}{lang value="Name"}{/if}</label>
                            <input name="item[name]" id="item_name" type="text" class="form-control validate[required,maxSize[140]]" value="{$item.name|escape}"/>
                            <span class="hint">{lang value="Required"}</span>
                        </div>

                        <div class="row-form">
                            <label>{lang value="Value"}</label>
                            <div class="radio radio-primary">
                                <input type="radio" value="1" id="plaintext" name="item[texttype]" checked="checked">
                                <label for="plaintext">{lang value="Plain Text"}</label>

                                <input type="radio" value="1" id="richtext" name="item[texttype]" checked="checked">
                                <label for="richtext">{lang value="Rich Text"}</label>
                            </div>
                            <textarea name="item[value]" id="item_value" class="form-control" style="height: 400px;">{$item.value|escape}</textarea>
                            {*<div class="span10">*}
                                {*<div class="row-form">*}
                                    {*<div class="span2">*}
                                        {*<label for="plaintext"><input id="plaintext" type="radio" name="item[texttype]" value="1" checked />{lang value='Plain Text'}</label>*}
                                    {*</div>*}
                                    {*<div class="span2">*}
                                        {*<label for="richtext"><input id="richtext" type="radio" name="item[texttype]" value="1" />{lang value='Rich Text'}</label>*}
                                    {*</div>*}
                                {*</div>*}
                                {*<textarea style="height: 400px;" name="item[value]" class="">{$item.value}</textarea>*}
                            {*</div>*}
                        </div>

                        {*<div class="toolbar bottom TAR">*}
                            {*<div class="btn-group">*}
                                {*<button class="btn btn-primary" id="submitForm" type="submit">Save Changes</button>*}
                            {*</div>*}
                        {*</div>*}

                    {*</div>*}
                {/form}
            </div>
        </div>
    {/nocache}
{/block}
{block name='script'}
    <script type="text/javascript">
        var table = $('#table-language');
        table.find('tr').click(function(e) {
            window.location.href = $(this).find('a').attr('href');
        });

        $("#table-language-selector").on("change", function(e) {
            $(this).closest('form').submit();
        });
    </script>
    <script>
        var ckeditor = false;
        $(document).ready(function(){
            $('#plaintext').click(function(e) {
                if (ckeditor) {
                    ckeditor.destroy();
                }
            });
            $('#richtext').click(function(e) {
                ckeditor = CKEDITOR.replace('item[value]');
            });
            {if $isHtml}
            $('#richtext').click();
            setTimeout(function(e) {
                $.uniform.update();
            }, 100);
            {/if}
        });
    </script>
{/block}