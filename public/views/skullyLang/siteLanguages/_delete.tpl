{extends file="admin/wrappers/_formDialog.tpl"}
{block name=dialogHeader}
    <h3 class="text-primary bold"><i class="pg-trash m-r-15"></iDelete {$params.id}</h3>
{/block}
{block name=dialogContent}
    {nocache}
        {form method="POST" action="{url path=$destroyPath}"}
            <input name="p" type="hidden" value="{$params.p}" />
            <input name="id" type="hidden" value="{$params.id}" />
            <input name="l" type="hidden" value="{$params.l}" />
            <div class="block-fluid">
                <div class="row">
                    <div class="col-sm-12 largerText">Delete item {$params.id}?</div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <span class="alert alert-warning">Warning: Not recoverable!</span>
                    </div>
                </div>
            </div>
        {/form}
    {/nocache}
{/block}
{block name=dialogButtons}
    <a class="btn btn-danger" onclick="return bootstrapModalSubmit();"><i class="pg-trash m-r-10"></i>Delete</a>
    <a class="btn" data-dismiss="modal"><i class="pg-close m-r-10"></i>Close</a>
{/block}