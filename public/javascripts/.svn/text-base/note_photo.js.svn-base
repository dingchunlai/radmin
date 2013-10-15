var ud=function(id){return document.getElementById(id)}
function choosemain(vlu){
        if(document.getElementById('logoimg'+vlu).src != "http://js.51hejia.com/images/up.gif"){
      		if(document.getElementById("main_"+vlu).innerHTML == "设为主图"){
      			if(parseInt(document.getElementById("main").value) != 0){
      				document.getElementById("main_"+parseInt(document.getElementById("main").value)).innerHTML = "设为主图";
      			}
      			document.getElementById("main").value = vlu;
      			document.getElementById("main_"+vlu).innerHTML = "<span style='color:red;'>取消(主图)</span>";
      		}else{
      			document.getElementById("main_"+vlu).innerHTML = "设为主图";
      			document.getElementById("main").value = 0;
      		}
  		}else{
  		    document.getElementById("main_"+vlu).innerHTML = "设为主图";
      		document.getElementById("main").value = 0;
  		}
  	}
    function clearFile(num){ 
        var fileHTML = ud('image'+num+'_uploaded_data').outerHTML; 
        var endIndex = fileHTML.indexOf("value"); 
        if(endIndex!=-1){ 
            ud('image'+num+'_uploaded_data').outerHTML = "<input name='image"+num+"[uploaded_data]' type='file' id='image"+num+"_uploaded_data'' onchange='getFullPath("+num+",this);'  size='40' style='float:left;'>"; 
        } 
    }
  	function getFullPath(num,obj){   
        var fileText =obj.value.substring(obj.value.lastIndexOf("."),obj.value.length);
        if (fileText!='.jpg'){
            alert("对不起，系统仅支持标准格式(.jpg)的照片，请您调整格式后重新上传，谢谢 ！");
    	    ud('logoimg'+num).src = "http://js.51hejia.com/images/up.gif";
    	    if (window.navigator.userAgent.indexOf("MSIE")>=1) { 
    	        clearFile(num);
    	    	choosemain(num);
    	   	}else if(window.navigator.userAgent.indexOf("Firefox")>=1){ 
    	    	ud('image'+num+'_uploaded_data').value = "";
    	   	}
        }else{
            var filesize = 0;
            if(obj) 
            { 
                if (window.navigator.userAgent.indexOf("MSIE")>=1) 
                { 
                    obj.select(); 
	                var filePath = obj.value;
			        var image=new Image();      
			        image.src=filePath;      
			        filesize=image.fileSize;
			        if(filesize >= 1024*100){
			        	alert("对不起，请重新选择小于100K之后重新上传，谢谢 ！");
			        	ud('logoimg'+num).src = "http://js.51hejia.com/images/up.gif";
			        	clearFile(num);
			        	choosemain(num);
			        }else{
			        	ud('logoimg'+num).src = document.selection.createRange().text;	
			        }
                }else if(window.navigator.userAgent.indexOf("Firefox")>=1){ 
                    if(obj.files) 
                    { 
                        filesize = obj.files[0].fileSize;
	                    if(filesize >= 1024*100){
	                        alert("对不起，请重新选择小于100K之后重新上传，谢谢 ！");
	                        ud('logoimg'+num).src = "http://js.51hejia.com/images/up.gif";
			        		ud('image'+num+'_uploaded_data').value = "";
			        		choosemain(num);
	                    }else{
	                        ud('logoimg'+num).src = obj.files.item(0).getAsDataURL();
	                    }
                    } 
                } 
            } 
        }
    } 
    
    function checkimg(filePath,num){
        var fileText = filePath.substring(filePath.lastIndexOf("."),filePath.length);
        var fileName = fileText.toLowerCase();//转化为小写
        if ((fileName!='.jpg')&&(fileName!='.gif')&&(fileName!='.jpeg')&&(fileName!='.png')&&(fileName!='.bmp'))
        {
            alert("对不起，系统仅支持标准格式的照片，请您调整格式后重新上传，谢谢 ！");
            document.getElementById('image'+num+'_uploaded_data').value = "";
            document.getElementById('logoimg'+num).src = "http://js.51hejia.com/images/up.gif";
        }
        else
        {
            alert(filePath);
            document.getElementById('logoimg'+num).src = filePath;
        }
    }
    function checkinfo(){
        var flg = true;
        if(ud('image1_uploaded_data').value == 0 && ud('image2_uploaded_data').value == 0 && ud('image3_uploaded_data').value == 0 && ud('image4_uploaded_data').value == 0 && ud('image5_uploaded_data').value == 0 ){
    	 	alert("请选择.jpg格式 | 且小于100K的图片进行上传，谢谢 ！ ");
    	 	flg = false;
    	}
    	if(ud('all').checked){
    	   if( ud('descriptidall').value == "" ){//ud('titleidall').value == "" ||
    	       alert("请输入统一的描述，装修阶段，局部空间信息！ ");
    	 	   flg = false;
    	   }
    	}else{
    	   for(i=1;i<=5;i++){
        	   if(ud('image'+i+'_uploaded_data').value != 0){
        	       if( ud('descript'+i).value == "" ){//ud('title'+i).value == "" ||
            	       alert('请为第 '+i+' 张图片添加描述，装修阶段，局部空间信息！ ');
            	 	   flg = false;
            	 	   break;
            	   }
        	   }
    	   }
    	}
  	    return flg;
  	}