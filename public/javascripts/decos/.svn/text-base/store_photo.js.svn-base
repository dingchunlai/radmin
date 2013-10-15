/**
 * @author maoqiuyun
 */
$(document).ready(function(){
	
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

    function uploadErrorHandler(event, id, file, error) {
        alert("上传失败,[ERROR]" + error.type + "_" + error.info);
    }

    function uploadSuccessHandler(event, id, file, response, data) {
        var ext = file.name.split('.');
        ext = ext[ext.length - 1];
        var image_id = $(parseXml(response)).find("id").text();
        var image_md5 =$(parseXml(response)).find("md5").text();
        var img_path = image_id + '-' + image_md5 +  '.' + ext;
		$("#photo_show").attr('src', ($("#store_form").attr("picture_prefix") + img_path));
        $("#photo_path").val(img_path);
		$("#picture_image_id").val(image_id);
		$("#picture_image_md5").val(image_md5);
		$("#picture_image_ext").val(ext);
		$("#picture_file_name").val(file.name);
        $("main_image_upload_button").attr('disabled', null);  //上传按钮解锁
    }

    //上传过程提示
    function uploadProgressHandler(event, id, file, data) {
    }
    
    function uploadCompleteHandler() {
      $('#main_image_upload_button').uploadifyClearQueue();
    };


    //上传等待过程
    function fileQueuedHandler(event, id, file) {
        //$("#upload_notice").text("正在上传图片，请稍后 ...");
        $("main_image_upload_button").attr('disabled', 'disabled');  //锁定上传按钮
        return false;
    }


    $("#main_image_upload_button").uploadify({
        auto        : true, // 自动开始上传文件
        script         : $("#store_form").attr("picture_prefix"),
        uploader       : '/swf/uploadify.swf', // 上传文件falsh
        expressInstall : 'swf/expressInstall.swf',
        cancelImg      : 'img/cancel.png', // 取消上传的按钮图片
        scriptData	:{
            "resize": '400x375',
            'watermark': '4c060a2d86869711c20004bb'
        },
        fileDataName: 'file', // 文件在POST中的参数名字
		
        fileDesc    : 'Image files', // 可选文件的描述
        fileExt     : '*.jpg;*.png;*.gif', // 可选文件的扩展名

        queueID     : 'fileQueue', // 文件列表的dom id
		filesSelected : 1,
        sizeLimit   : 200 * 1024, // 上传文件的大小控制（字节，这里表示500Kb）
        multi       : false, // 允许上传多个文件
        simUploadLimit : 1, // 允许同时进行上传的文件数

        buttonText  : '上传', // 上传按钮的文字
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
        onProgress: uploadProgressHandler,
        // 一个队列上传完成
        onAllComplete: uploadCompleteHandler
    });
	
	
	$("#store_form").submit(function(){
		if($.trim($("#picture_file_name").val()).length == 0){
			alert("请上传图片");
			return false;		
		}
	});
});