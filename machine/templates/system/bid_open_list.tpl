{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// 処理 ////
    $('button.delete').click(function() {
        var $_self = $(this);
        var data = {
            'id': $.trim($_self.val()),
        }
        
        // 送信確認
        if (!confirm("id : " + data['id'] + "\nこの入札会情報を削除します。よろしいですか。\n\n※ 終了した入札会の場合、\n「過去の入札会」からも削除されます。")) { return false; }
        
        $.post('/system/ajax/bid.php', {
            'target': 'system',
            'action': 'deleteOpen',
            'data'  : data,
        }, function(res) {
            if (res != 'success') {
                alert(res);
                return false;
            }
            
            // 登録完了
            alert('削除が完了しました');
            // location.href = '/system/bid_open_list.php';
            
            $_self.closest('tr').remove();
            return false;
        }, 'text');
        
        return false;
    });
});
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}

<table class='list contact'>
  <thead>
    <tr>
      <th class='id'>ID</th>
      <th class="title">タイトル</th>
      <th class="organizer">主催者名</th>
      <th class="">下見期間</th>
      <th class="entry_start_date">入札締切</th>
      <th class="condition">状況</th>
      <th class="delete">削除</th>
    </tr>
  </thead>
  
  {foreach $bidOpenList as $b}
    <tr>
      {if in_array($b.status, array('carryout', 'after'))}
        <td class='id' rowspan="2">{$b.id}</td>
        <td class='title' rowspan="2">
          <a href="/system/bid_open_form.php?id={$b.id}">{$b.title}</a>
      {else}
        <td class='id'>{$b.id}</td>
        <td class='title'>
          <a href="/system/bid_open_form.php?id={$b.id}">{$b.title}</a>
        </td>
      {/if}
      <td class='organizer'>{$b.organizer}</td>
      <td class=''>{$b.preview_start_date|date_format:'%Y/%m/%d'} ～ {$b.preview_end_date|date_format:'%m/%d'}</td>
      <td class=''>{$b.user_bid_date|date_format:'%m/%d %H:%M'}</td>
      <td class='condition'>{BidOpen::statusLabel($b.status)}</td>      
      <td class='delete'>
        <button class="delete" value="{$b.id}">削除</a>
      </td>
    </tr>
    
    {if in_array($b.status, array('carryout', 'after'))}
      <tr>
        <td colspan="5">
          落札結果(
          <a href="system/bid_list.php?o={$b.id}">一覧</a>| 
          <a href="system/bid_result.php?o={$b.id}&output=csv">CSV</a>
          )
          落札・出品集計(
          <a href="system/bid_result.php?o={$b.id}" target="_blank">一覧</a>|
          <a href="system/bid_result.php?o={$b.id}&output=csv&type=sum">CSV</a>|
          <a href="system/bid_result.php?o={$b.id}&output=pdf&type=sum" target="_blank">PDF</a>
          )
          <a href="system/bid_result.php?o={$b.id}&output=pdf&type=receipt" target="_blank">領収証PDF</a>
        </td>
      <tr>
    {/if}
  {/foreach}
</table>
{/block}
