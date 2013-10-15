jQuery(document).ready(function($) {
  var	data_image_prefix_array = $("#picyl").attr("data_image_prefix_array").split(",");
	var img_num = $("#picyl tr").length + 1;
		function parseXml(xml) {
			if (window.DOMParser)
			  {
			  parser=new DOMParser();
			  xmlDoc=parser.parseFromString(xml,"text/xml");
			  }
			else // Internet Explorer
			  {
			  xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
			  xmlDoc.async="false";
			  xmlDoc.loadXML(xml);
			  }
			return xmlDoc;
		};
		$(".insert_img_to_editor").livequery('click',function() {
			CKEDITOR.instances.diary_content_editor.insertHtml( '<img src="'+$(this).attr("href")+'" />');
			return false;
		});
		
		$(".delete_picture").livequery('click',function() {
			$(this).parent().parent().html("").hide();
			if ($(this).attr("id").length>0) {
				$.ajax({
						type: "POST",
						url:'/pictures/destroy',
						dataType:"script",
						data: {id:$(this).attr("id")}
				});
			};
			return false;
		});

    function file_item(id) {
			

      var tr_id = 'f' + id;
      var item = $('#' + tr_id);
      if (item.size() < 1) {
        item = $('<tr/>').attr('id', tr_id).appendTo('#picyl tbody');
        for(var i = 0; i < 4; i++) $('<td/>').appendTo(item);
      }
      return item;
    }

  function uploadErrorHandler(event, id, file, error) {
	if (error.type=="File Size") {
		file_item(id).find('td').eq(1).text(file.name + "上传失败").end().eq(2).text("因为图片尺寸超过200K");
	}else{
		file_item(id).find('td').eq(1).text(error.type).end().eq(2).text(error.info);
	};
    

    return false;
  }

  function uploadSuccessHandler(event, id, file, response, data) {
		
			var ext = file.name.split('.');
		      ext = ext[ext.length - 1];
			var image_id = $(parseXml(response)).find("id").text();
			var image_md5 = $(parseXml(response)).find("md5").text();
			var data_index = $("#picyl").attr("data_index");
			var image_prefix = data_image_prefix_array[ img_num % data_image_prefix_array.length];
			var img_path = image_id + '-' + image_md5 +  '.' + ext;
			var file_name = file.name;
			var img_path_with_domain = image_prefix + img_path ;
			
			// 存入数据库
			$.ajax({
					type: "POST",
					url:'/pictures',
					dataType:"json",
					data: { "picture[item_id]":$("#picyl").attr("data_deco_firm_id"), 
									"picture[image_id]":image_id,
									"picture[image_md5]":image_md5,
									"picture[file_name]":file_name,
									"picture[item_type]":"DecoFirm",
									"picture[image_ext]":ext },
					success: function() {
						//alert("保存成功");
					}
			});
			
			img_num ++;

		      file_item(id).find('td').
						eq(0).html('<span class="scrj_czt02_pic"><a rel="dropmenu'+ img_num +'"><img src="http://js.51hejia.com/img/zxdpimg/zxrj_picicon.gif"/> '+ file_name +'</a></span>' +
											 '<div id="dropmenu'+ img_num +'" class="scrj_piclist">' +
											 '<img src="' + img_path_with_domain + '"  width="160" height="120"/> </div> ' +
											 ' <a href="#" target="_self" title="删除" class="scrj_czt02_sc delete_picture">删除</a>' ).end().
						eq(1).html('上传成功').end().
						eq(2).html('');
						cssdropdown.startchrome("picyl");
	
  }


  function uploadProgressHandler(event, id, file, data) {
    file_item(id).find('td').eq(2).text(data.percentage + '%(' + data.speed + ')');
  }

  function fileQueuedHandler(event, id, file) {
		file_item(id).find('td').eq(0).text(file.name).end().
    eq(1).text('等待上传');
		
		this.startUpload(file.id);
		return false;
  }

  function onCancel() { return false }

  function log(msg) {
    if(console) console.log(msg);
  }

  $("#swfupload_button").uploadify({
    auto        : true, // 自动开始上传文件
    // 路径
   // script         : 'http://192.168.0.15:8081', // 处理上传的地址
		script				:$("#picyl").attr("picture_prefix"),
    uploader       : '/swf/uploadify.swf', // 上传文件falsh
    expressInstall : 'swf/expressInstall.swf',
    cancelImg      : 'img/cancel.png', // 取消上传的按钮图片
		scriptData	:{"resize": '500x375', 'watermark': '4c060a2d86869711c20004bb'},
    fileDataName: 'file', // 文件在POST中的参数名字

    fileDesc    : 'Image files', // 可选文件的描述
    fileExt     : '*.jpg;*.png;*.gif', // 可选文件的扩展名

    queueID     : 'fileQueue', // 文件列表的dom id

    sizeLimit   : 200 * 1024, // 上传文件的大小控制（字节，这里表示500Kb）
    multi       : true, // 允许上传多个文件
    simUploadLimit : 1, // 允许同时进行上传的文件数

    //buttonText  : '上传', // 上传按钮的文字
    buttonImg   : '/images/icons/upload.png', // 上传按钮图片
    rollover    : true, // 是否使用sprint图片（一张图片多张小图）－没有swfupload流畅
    width       : 80,
    height      : 25,

    // 选择了文件时
    onSelect: fileQueuedHandler,
    // 单个文件上传成功的处理函数
    onComplete: uploadSuccessHandler,
    // 文件上传失败的处理函数
    onError:    uploadErrorHandler,
    // 处理文件上传进度的函数
    onProgress: uploadProgressHandler
  });

  $('#clean_queue').click(function(event) {
    event.preventDefault();
    $('#swfupload_button').uploadifyClearQueue()
    return false;
  });
});
