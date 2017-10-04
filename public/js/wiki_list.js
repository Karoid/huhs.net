  /* 모바일 무한 스크롤 */
var page = parseInt($("nav div em").html())
var loading_state = false
$(document).scroll(function(event) {
  console.log('scroll'+$(document).scrollTop(),'article'+($("#article").height() - $(window).height()+89), loading_state)
  if (Math.round($(document).scrollTop()) >= $("#article").height() - $(window).height()+89 && loading_state == false) {
    loading_state = true
    loading = $('<div id="loading" class="load" style="display: none;"><span><img src="http://www.downgraf.com/wp-content/uploads/2014/09/01-progress.gif" alt="cargando..."/></span></div>');
    $('table.article_list').after(loading);
    loading.fadeIn();
    $.ajax({
      type: 'GET',
      url: window.location.href + "?page="+(page+1),
      dataType: 'json',
      data: {json:true},
      success: (function(data) {
        return loading.fadeOut(function() {
          var html = ""
          $.each(data,function(index, article) {
            var datetime = new Date(article.updated_at)
            console.log(article)
            html += '<tr>'+
            '<td class="td_number" scope="row">'+article.id+'</th>'+
            '<td class="td_title"><a href="/wiki/'+encodeURIComponent(article.path)+'">'+article.title+'</a></td>'+
            '<td class="td_name">'+article.member_name+'</td>'+
            '<td class="td_date"><span class="hidden-xs">'+datetime.getFullYear()+'.</span>'+("0" + (datetime.getMonth() + 1)).slice(-2)+"."+("0" + datetime.getDate()).slice(-2)+'</td>'+
            '<td class="td_page_view">'+article.view+'</td>'+
            '</tr>'
          });
          $('table.article_list tbody').append(html);
          $('.load').remove()
          page += 1
          return loading.remove();
        });
      }),
      error: function(err){
        $('nav').show()
        return loading.remove();
      },
      complete: function(){
        loading_state = false
      }
    });
    }
});

//검색 상태 표시
if (/search/.exec(window.location.search)) {
  $("form.search").empty().append('<div class="searched_tag">'+decodeURIComponent(window.location.search.split("=")[1])+' 검색됨  <i class="icon icon-remove" aria-hidden="true"></i></div>')
  .click(function(event) {
    window.location = window.location.pathname
  });
}
