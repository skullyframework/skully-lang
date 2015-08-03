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

                {include file='admin/widgets/_alerts.tpl' }
                <table id="table-language" cellpadding="0" cellspacing="0" width="100%" class="table table-hover">
                    <thead>
                    {if $mode == 'dir'}
                        <tr>
                            <th class="text-left">Name</th>
                            <th class="text-right" style="width: 120px">Last Modified</th>
                        </tr>
                    {else}
                        <tr>
                            <th class="text-left" style="width: 200px">Name</th>
                            <th class="text-left">Value</th>
                        </tr>
                    {/if}
                    </thead>
                    <tbody>
                    {if $mode == 'dir'}
                        {foreach $items as $item}
                            <tr>
                                <td>
                                    <a href="{url path=$indexPath p={$item.path} l={$params['l']}}"><i class="{if $item.type == 'dir'}fa fa-folder{else}fa fa-file{/if} icon-inline"></i><span>{$item.name}</span></a>
                                </td>
                                <td class="text-right">
                                    {$item.updatedAt}
                                </td>
                            </tr>
                        {/foreach}
                    {else}
                        {foreach $items as $item}
                            <tr>
                                <td>
                                    <a href="{url path=$editPath p={$item.path} id={$item.name} l={$params['l']}}"><span>{$item.name}</span></a>
                                </td>
                                <td>
                                    {$item.value|strip_tags|truncate:200:TRUE}
                                </td>
                            </tr>
                        {/foreach}
                    {/if}
                    </tbody>
                </table>
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
{/block}