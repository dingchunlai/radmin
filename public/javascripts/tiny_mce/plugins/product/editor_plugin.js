(function(){tinymce.PluginManager.requireLangPack("product");tinymce.create("tinymce.plugins.productPlugin",{init:function(a,b){a.addCommand("mceproduct",function(){a.windowManager.open({file:b+"/product.html",width:320,height:120,inline:1},{plugin_url:b,some_custom_arg:"custom arg"})});a.addButton("product",{title:"product",cmd:"mceproduct",image:b+"/img/upload.gif"});a.onNodeChange.add(function(d,c,e){c.setActive("product",e.nodeName=="IMG")})},createControl:function(b,a){return null},getInfo:function(){return{longname:"product plugin",author:"Some author",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/product",version:"1.0"}}});tinymce.PluginManager.add("product",tinymce.plugins.productPlugin)})();