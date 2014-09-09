{extends file="admin/wrappers/_formDialog.tpl"}
{block name=dialogHeader}
    <h3>Delete {$params.id}</h3>
{/block}
{block name=dialogContent}
    {nocache}
        {form method="POST" action="{url path=$destroyPath}"}
            <input name="p" type="hidden" value="{$params.p}" />
            <input name="id" type="hidden" value="{$params.id}" />
            <input name="l" type="hidden" value="{$params.l}" />
            <div class="block-fluid">
                <div class="row-form">
                    <div class="span12 largerText">Delete item {$params.id}?</div>
                </div>
                <div class="row-form">
                    <div class="span12">Warning: Not recoverable!</div>
                </div>
            </div>
        {/form}
    {/nocache}
{/block}
{block name=dialogButtons}
    <a class="btn btn-danger" onclick="return bootstrapModalSubmit();">Delete</a>
    <a class="btn" data-dismiss="modal">Close</a>
{/block}