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
            <div class="block-fluid">
                {if (!empty($message))}
                    <div class="row-form">
                        <div class="span12">
                            <div class="alert alert-error">{$message}</div>
                        </div>
                    </div>
                {/if}
                <div class="row-form">
                    <div class="span12">
                        <h3>Item Not Found</h3>
                        <p>Create it</p>
                    </div>
                </div>
            </div>
        </div>
    {/nocache}
{/block}
{block name='script'}
    <script type="text/javascript">
        $("#table-language-selector").on("change", function(e) {
            $(this).closest('form').submit();
        });
    </script>
{/block}