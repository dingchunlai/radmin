 var swfu;

  $(document).ready(function() {

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
			$(this).parents("tr").html("").hide();
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

    function file_item(file) {
      var tr_id = 'f' + file.id;
      var item = $('#' + tr_id);
      if (item.size() < 1) {
        item = $('<tr/>').attr('id', tr_id).appendTo('#picyl');
        for(var i = 0; i < 4; i++) $('<td/>').appendTo(item);
      }
      return item;
    }

    function uploadErrorHandler(file, code, message) {
	    alert(code + ' | ' + message);
      file_item(file).find('td').eq(1).text('ERROR').end().
      eq(2).text(SWFUpload.UPLOAD_ERROR[code] + "\n" + message);
    }

    function uploadSuccessHandler(file, data, response) {
			var ext = file.name.split('.');
		      ext = ext[ext.length - 1];
			var image_id = $(parseXml(data)).find("id").text();
			var image_md5 =$(parseXml(data)).find("md5").text();
			var data_index = $("#picyl").attr("data_index");
			var image_prefix = data_image_prefix_array[ img_num % data_image_prefix_array.length];
			var img_path = image_id + '-' + image_md5 +  '.' + ext;
			var file_name = file.name;
			var img_path_with_domain = image_prefix + img_path ;
			img_num ++;

		      file_item(file).find('td').
						eq(0).html('<a href="'+ img_path_with_domain +'" class="scrj_czt02_cr insert_img_to_editor" title="将该图片插入至文档">插入</a>').end().
						eq(1).html('<span class="scrj_czt02_pic"><a rel="dropmenu'+ img_num +'"><img src="http://js.51hejia.com/img/zxdpimg/zxrj_picicon.gif"/> '+ file_name +'</a></span>' +
											 '<div id="dropmenu'+ img_num +'" class="scrj_piclist">' +
											 '<img src="' + img_path_with_domain + '"  width="200" height="150"/></div>' +
											 '<a href="#" target="_self" title="删除图片" class="scrj_czt02_sc delete_picture">删除图片</a>' ).end().
						eq(2).html('<input name="pictures[][is_master]" type="radio" value="1" class="f_l master" />' + '<span class="scrj_czt02_jdt"><label style="width:155px;"></label></span>').end().
						eq(3).html('<span class="nothing"><select name="pictures[][space]" size="1" class="space">' +
											'<option value="">请选择</option>' +
											'<option value="1">厨房</option>' +
											'<option value="2">餐厅</option>' +
											'<option value="3">客厅</option>' +
											'<option value="4">卫生间</option>' +
											'<option value="5">卧室</option>' +
											'<option value="6">书房</option>' +
											'<option value="7">儿童房</option>' +
											'<option value="8">衣帽间</option>' +
											'<option value="9">阳台</option>' +
											'<option value="10">阁楼</option>' +
											'<option value="11">花园</option>' +
											'<option value="12">飘窗</option>' +
											'<option value="13">储藏室</option>' +
											'<option value="14">阳光房</option>' +
											'<option value="15">玄关</option>' +
											'<option value="16">过道</option>' +
											'<option value="17">其他</option>' +
											'</select></span>' +
											'<input type="hidden" name="pictures[][image_id]"  value = "'+image_id+'"/>' +
											'<input type="hidden" name="pictures[][image_md5]"  value = "'+ image_md5 +'"/>' +
											'<input type="hidden" name="pictures[][image_ext]"  value = "'+ ext +'"/>' +
											'<input type="hidden" name="pictures[][file_name]"  value = "'+ file_name +'"/>' +
											'<input type="hidden" name="pictures[][id]" value = "" class="image_id"/>');
						cssdropdown.startchrome("picyl");

		}
		
		function uploadCompleteHandler(file) {
			var file = this.getQueueFile(0);
			if(file) { 
					this.addPostParam("resize","500x375");
          this.addPostParam("watermark", "4c23086a8686973159000c7b");
					this.startUpload(file.id);
			}
		}
		
    function uploadStartHandler(file) {
      file_item(file).find('td').eq(1).text('正在上传').end().eq(2).text('0%');
    }

    function uploadProgressHandler(file, uploaded, total) {
      file_item(file).find('td').eq(2).text(Math.round(uploaded / total) + '%');
    }

    function swfuploadPreloadHandler() {
      $('#swfupload_button').text('Upload component is loading, please wait ...');
    }

    function fileQueuedHandler(file) {
      file_item(file).find('td').eq(0).text(file.name).end().
      eq(1).text('等待上传');
			this.addPostParam("resize", "500x375");
			this.addPostParam("watermark", "4c23086a8686973159000c7b");
			this.startUpload(file.id);
    }

		function fileQueueError(file, errorCode, message) {
		try {
		// Handle this error separately because we don't want to create a FileProgress element for it.
		switch (errorCode) {
		case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED:
		alert("You have attempted to queue too many files.\n" + (message === 0 ? "You have reached the upload limit." : "You may select " + (message > 1 ? "up to " + message + " files." : "one file.")));
		return;
		case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
		alert( "图片 " + file.name + " 尺寸超过200K , 该文件没有被上传");
		this.debug("Error Code: File too big, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
		return;
		case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
		alert(file.name + "是一个空文件, 该文件没有被上传");
		return;
		case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
		alert("您所选择的文件不能上传.");
		this.debug("Error Code: Invalid File Type, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
		return;
		default:
		alert("An error occurred in the upload. Try again later.");
		this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
		return;
		}
		} catch (e) {
		}
		}

    swfu = new SWFUpload({
      upload_url : $("#picyl").attr("picture_prefix"),
      //flash_url  : "/swf/swfupload.swf",
     // flash9_url : "/swf/swfupload_fp9.swf",

			flash_url  : "/swf/uploadify.swf",
      file_post_name  : 'file',
      file_size_limit : "200 KB",
      file_types      : '*.jpg;*.png',
      file_types_description: 'Image files',
      assume_success_timeout: 0,
      http_success    : [201, 204],

      button_placeholder_id : 'swfupload_button',
      button_image_url      : '/images/icons/upload.png',
			button_window_mode	  : SWFUpload.WINDOW_MODE.OPAQUE,
			/*
			debug_handler : function (message) {
			alert("[DEBUG]" + message);
			},
			swfupload_load_failed_handler : function() {
			alert("swfupload load failed");
			},
			swfupload_loaded_handler : function() {
			alert("swfupload loaded!");
			},*/ 
  //     button_text: '添加图片',
      /* handlers */
		//ebug				: true,
      swfupload_preload_handler : swfuploadPreloadHandler,
      file_queued_handler     : fileQueuedHandler,
      upload_start_handler    : uploadStartHandler,
      upload_progress_handler : uploadProgressHandler,
      upload_error_handler    : uploadErrorHandler,
      upload_success_handler  : uploadSuccessHandler,
			upload_complete_handler : uploadCompleteHandler,
			file_queue_error_handler : fileQueueError
    });
  });

  $(document).unload(function() {
    /* Prevent memory leaks in IE */
    try { swfu.destroy() } catch(e) { /* noop */ }
  });
