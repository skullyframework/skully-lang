{extends file='admin/wrappers/_main.tpl'}
{block name='content'}
    {nocache}
        <div class="widget">
            <div class="head dark">
                <div class="icon"><span class="icos-book"></span></div>
                <h2>Site Language Manager</h2>
            </div>
            <div class="toolbar">
                {include file='skullyLang/siteLanguages/_toolbar.tpl'}
            </div>
            {form class="validate" method="POST" action="{url path=$formPath}"}
                <div class="block-fluid">
                    {include file='admin/widgets/_alerts.tpl' }
                    <div class="row-form">
                        <div class="span10 largerText">
                            <input name="p" type="hidden" value="{$params.p}" />
                            <input name="id" type="hidden" value="{$params.id}" />
                            <input name="l" type="hidden" value="{$params.l}" />
                            {if $_path.action == 'edit' || $_path.action == 'update'}Edit {$item.name}{else}New Item{/if}
                        </div>
                    </div>
                    <div class="row-form">
                        <div class="span2">{if $_path.action == 'edit' || $_path.action == 'update'}{lang value="Change Name"}{else}{lang value="Name"}{/if}</div>
                        <div class="span10">
                            <input name="item[name]" type="text" class="validate[required,maxSize[140]]" value="{$item.name}"/>
                            <span class="bottom">{lang value="Required"}</span>
                        </div>
                    </div>

                    <div class="row-form">
                        <div class="span2">{lang value="Value"}</div>
                        <div class="span10">
                            <div class="row-form">
                                <div class="span2">
                                    <label for="plaintext"><input id="plaintext" type="radio" name="item[texttype]" value="1" checked />{lang value='Plain Text'}</label>
                                </div>
                                <div class="span2">
                                    <label for="richtext"><input id="richtext" type="radio" name="item[texttype]" value="1" />{lang value='Rich Text'}</label>
                                </div>
                            </div>
                            <textarea style="height: 400px;" name="item[value]" class="">{$item.value}</textarea>
                        </div>
                    </div>

                    <div class="toolbar bottom TAR">
                        <div class="btn-group">
                            <button class="btn btn-primary" id="submitForm" type="submit">Save Changes</button>
                        </div>
                    </div>

                </div>
            {/form}
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