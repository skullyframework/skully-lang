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
                {include file='admin/widgets/_alerts.tpl' }
                <table id="table-language" cellpadding="0" cellspacing="0" width="100%" class="table-hover">
                    <thead>
                        {if $mode == 'dir'}
                            <tr>
                                <th class="TAL">Name</th>
                                <th class="TAR" style="width: 120px">Last Modified</th>
                            </tr>
                        {else}
                            <tr>
                                <th class="TAL" style="width: 200px">Name</th>
                                <th class="TAL">Value</th>
                            </tr>
                        {/if}
                    </thead>
                    <tbody>
                    {if $mode == 'dir'}
                        {foreach $items as $item}
                            <tr>
                                <td>
                                    <a href="{url path=$indexPath p={$item.path} l={$params['l']}}"><i class="{if $item.type == 'dir'}icosg-folder{else}icosg-file{/if} icon-inline"></i><span>{$item.name}</span></a>
                                </td>
                                <td class="TAR">
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