
jQuery(document).ready(function($) {
  var full_toolbar = [ 'undo', 'redo', 'print', 'cut', 'copy', 'paste',
   'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
   'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
   'superscript', '|', 'selectall', '-',
   'title', 'fontname', 'fontsize', '|', 'textcolor', 'bgcolor', 'bold',
   'italic', 'underline', 'strikethrough', 'removeformat', '|',
   'flash', 'media', 'advtable', 'hr', 'emoticons', 'link', 'unlink', '|', 'about'];
  var simple_toolbar =  [ 'undo', 'redo',  'cut', 'copy', 'paste',
   '|', 'justifyleft', 'justifycenter', 'justifyright',
    'justifyfull', 'emoticons', 
    'superscript', '|', 'fontname', 'fontsize', 'link', 'unlink', '|', 'textcolor', 'bgcolor', 'bold',
    'italic', 'underline', 'strikethrough'];
  
      
  $.each($('.kindeditor'), function(index, val) {
    if ($(this).attr("data-toolbar") == "simple") {
      var toolbar = simple_toolbar;
    }else{
      var toolbar = full_toolbar;
    };
    
    KE.show({
       id: this.id,
       items: toolbar
     })
  });

});

 
