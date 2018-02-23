//= require tui-code-snippet/dist/tui-code-snippet
//= require markdown-it/dist/markdown-it
//= require to-mark/dist/to-mark
//= require codemirror/lib/codemirror
//= require highlightjs/highlight.pack
//= require squire-rte/build/squire
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

function init(){
  var el = $('#textarea')
  var editor = $('#tui-editor')
  //initialize tuiEditor
    editor.tuiEditor({
      initialEditType: 'markdown',
      initialValue: $('#textarea').text(),
      viewer: false,
      previewStyle: preview_style(),
      height: 500,
      exts: ['scrollSync']
    });
    el.hide()
}
$(document).ready(function() {
  var el = $('#textarea')
  var editor = $('#tui-editor')
  try {
    init()
  } catch (e) {
    setTimeout(init,500)
  }
  $('.wiki_form').submit(function(event) {
    if($('#page_title').val().indexOf("#") >= 0){
      return el.text(editor.tuiEditor('getValue'))
    }else{
      alert('제목에 분류를 표시하지 않았습니다!, #을 이용해 표시해주세요')
      $('#page_title').css('background', '#ff00003d');
      return false
    }
  });

});
