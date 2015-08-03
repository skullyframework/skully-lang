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

                {if (!empty($message))}
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="alert alert-danger">{$message}</div>
                        </div>
                    </div>
                {/if}
                <div class="row">
                    <div class="col-sm-12">
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