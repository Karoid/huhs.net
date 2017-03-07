$('.pagination a').click(pagination_click_desktop)
function pagination_click_desktop(event) {
var page = parseInt(this.innerHTML)
var loading;
var thisLink = $(this)
event.preventDefault();
$.ajax({
  type: 'GET',
  url: $(this).attr('href'),
  dataType: 'json',
  data: {json:true},
  success: (function(data) {
    $('table.article_list tbody').html("");
    //게시판 내용 갱신
    var html = ""
    $.each(data,function(index, article) {
      var datetime = new Date(article.created_at)
      html += '<tr>'+
      '<td class="td_number" scope="row">'+article.id+'</th>'+
      '<td class="td_title"><a href="/board/'+window.location.pathname.split("/")[2]+'/'+window.location.pathname.split("/")[3]+'/'+article.id+'">'+article.title+'</a></td>'+
      '<td class="td_name">'+article.member_name+'</td>'+
      '<td class="td_date"><span class="hidden-xs">'+datetime.getFullYear()+'.</span>'+datetime.getMonth()+"."+datetime.getDate()+'</td>'+
      '<td class="td_page_view">'+article.view+'</td>'+
      '</tr>'
    });
    $('table.article_list tbody').html(html);
    //게시판 페이지네이션 갱신
    var before_current = $(".pagination em")
    var link = $('<a href="'+window.location.href+'?page='+before_current.html()+'">'+before_current.html()+'</a>').click(pagination_click_desktop)
    var current = $('<em class="current">'+thisLink.html()+'</em>')
    before_current.after(link).remove()
    console.log(thisLink);
    $('.pagination a').removeAttr('rel')
    thisLink.next().attr('rel','next')
    thisLink.after(current).remove()
  })
});
false;
}
/* 모바일 무한 스크롤 */
var page = parseInt($("nav div em").html())
$("#board").scroll(function() {
  console.log($("#board").scrollTop(),Math.round($("#board").scrollTop()), $("#article").height()- $(window).height()+89);
    if (Math.round($("#board").scrollTop()) >= $("#article").height() - $(window).height()+89) {
      console.log(++page);
loading = $('<div id="loading" class="load" style="display: none;"><span><img src="http://www.downgraf.com/wp-content/uploads/2014/09/01-progress.gif" alt="cargando..."/></span></div>');
$('table.article_list').after(loading);
loading.fadeIn();
$.ajax({
  type: 'GET',
  url: window.location.href + "?page="+page,
  dataType: 'json',
  data: {json:true},
  success: (function(data) {
    return loading.fadeOut(function() {
      var html = ""
      $.each(data,function(index, article) {
        var datetime = new Date(article.created_at)
        console.log(datetime,datetime.getYear())
        html += '<tr>'+
        '<td class="td_number" scope="row">'+article.id+'</th>'+
        '<td class="td_title"><a href="/board/'+window.location.pathname.split("/")[2]+'/'+window.location.pathname.split("/")[3]+'/'+article.id+'">'+article.title+'</a></td>'+
        '<td class="td_name">'+article.member_name+'</td>'+
        '<td class="td_date"><span class="hidden-xs">'+datetime.getFullYear()+'.</span>'+datetime.getMonth()+"."+datetime.getDate()+'</td>'+
        '<td class="td_page_view">'+article.view+'</td>'+
        '</tr>'
      });
      $('table.article_list tbody').append(html);
      $('.load').remove()
      return loading.remove();
    });
  })
});
}
});

//검색 상태 표시
if (window.location.search) {
  $("form.search").empty().append('<div class="searched_tag">'+decodeURIComponent(window.location.search.split("=")[1])+' 검색됨  <i class="icon icon-remove" aria-hidden="true"></i></div>')
  .click(function(event) {
    window.location = window.location.pathname
  });
}
