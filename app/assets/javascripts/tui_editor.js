//= require tui-editor/dist/tui-editor-Editor.min
//= require tui-editor/dist/tui-editor-extScrollSync.min

function preview_style(){
  var is_desktop = $('.logo_detail').is(':visible')
  if (is_desktop) {
    return 'vertical'
  }else{
    return 'tab'
  }
}

$(document).ready(function() {
  var el = $('#textarea')
  var editor = $('#tui-editor')
  var image = []

  function init(){
    initial_value = $('#textarea').text()
    if(initial_value.length == 0){
      initial_value = '### 기본정보\n' +
        '생년월일: YYYY.MM.DD  \n' +
        '주전공: 홍길동학부  \n' +
        '복수전공/부전공: 홍길동학과  \n' +
        '학적: 대전 홍길동고  \n' +
        '학번: 00학번  \n' +
        '혈액형: ABO  \n' +
        '\n' +
        '### 활동내역\n' +
        'YYYY년 0학기 입부  \n' +
        'YYYY년 0학기 회장\n' +
        '\n' +
        '### 성격/특징\n' +
        '그는 분신술의 귀재이다.  \n' +
        '\n' +
        '### 별명\n' +
        '홍길동'
    }

    //initialize tuiEditor
    editor.tuiEditor({
      initialEditType: 'markdown',
      initialValue: initial_value,
      viewer: false,
      previewStyle: preview_style(),
      height: 700,
      events: {
        load: catchExit,
        keyup: function(){
          $('#count').html(editor.tuiEditor('getValue').length+'자 작성')
        }
      },
      hooks: {
        addImageBlobHook: uploadImage
      },
      language: "ko_KR",
      exts: ['scrollSync']
    });
    el.hide()
  }

  function uploadImage(blob,callback){
      //blob: 받은 이미지 blob
      //callback: 넘겨줄 콜백함수. 형태는 callback('이미지 URL')
      var formData = new FormData();
      var loading_img = "<img src='/images/loading_icon.gif' class='loading_img' height='500px'/>"
      formData.append('file', blob);
      formData.append('post_id', 0);
      editor.hide();
      $('#textarea').after(loading_img)
      $.ajax({
        url: '/upload_image',
        type: 'POST',
        cache: false,
        contentType: false,
        processData: false,
        data: formData,
        success: function(data){
          image.push(data.image_id)
          callback(data.link);
        },
        error:function(e) {
          /* return blob */
          reader = new FileReader();
          reader.onload = function(event) {
            callback(event.target.result);
          };
          reader.readAsDataURL(blob);
        },
        complete : function () {
          editor.show();
          $('.loading_img').remove()
          editor.tuiEditor('focus');
        }
      })

  }

  function catchExit(){
    var route_match
    //제목에서 tab 키를 누르면 에디터가 focus됩니다
    $(window).keyup(function (e) {
      var code = (e.keyCode ? e.keyCode : e.which);
      if (code == 9 && $('p a[target=_blank]:focus').length) {
          editor.tuiEditor('focus')
      }
    });
    //페이지가 변경되면
    $(window).on("turbolinks:load",function(){
      route_match = /\/wiki\/new\//.test(window.location.pathname) || /\/wiki\/edit\//.test(window.location.pathname)

      if(route_match == false && image.length > 0){
        route_match = true
        img_destroy_ajax()
        route_match = false
        image = []
      }
    })
    //나갈때
    $(window).bind('beforeunload', function() {
      route_match = /\/wiki\/new\//.test(window.location.pathname) || /\/wiki\/edit\//.test(window.location.pathname)
      img_destroy_ajax()
      //확인 창을 띄우지 않으려면 아무 내용도 Return 하지 마세요!! (Null조차도)
    });

    function img_destroy_ajax(){
      if (image.length > 0 && route_match){
        for (var x in image) {
          $.ajax({
            url: '/upload_destroy',
            type: 'post',
            data: {public_id: image[x]},
            error: function(xhr,msg) {
              /* Act on the event */
              console.log(xhr,msg);
            }
          })
        }

      }
    }

  }

  //init exec
  try {
    init()
  } catch (e) {
    setTimeout(init,500)
  }
  $('.wiki_form').submit(function(event) {
    if($('#page_title').val().indexOf("#") >= 0){

      //이미지 정리 무력화
      $(window).off("beforeunload");

      el.text(editor.tuiEditor('getValue'))

      if(el.text().length < 150){
        alert('내용이 150자 이상이여야 합니다')
        return false
      }
    }else{
      alert('제목에 분류를 표시하지 않았습니다!, #을 이용해 표시해주세요')
      $('#page_title').css('background', '#ff00003d');
      return false
    }
  });

});
