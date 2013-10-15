$(document).ready(function() {
	
  function isRightMobileNumber(s){
    var patrn=/^0?1(4\d|3\d|5[012356789]|8[056789])\d{8}$/;
    if (!patrn.exec(s)) return false
    return true
  }
	
  $("#mobile_verify").click(function() {
    var code = $("#mobile_number").val();
    var mobile = $("#mobile").val();
    $.ajax({
      type: "POST",
      url: "/user/verify_mobile_code",
      dataType:"json",
      data: "&code="+code+"&mobile="+mobile ,
      success: function(data){
        if (data==1) {
          $("#mobile_verify").remove();
          $.fancybox.close();
        }else{
          alert("验证码错误,请重新输入.")
        };
    }
    });
  });
	
  $("#mobile_button").click(function() {
    var mobile_num = $("#mobile").val();
    if(isRightMobileNumber(mobile_num)){
      $(this).val("正在发送..").attr("disabled","disabled");
      $.ajax({
        type: "POST",
        url: "/user/send_mobile_code",
        dataType:"script",
        data: "&mobile="+mobile_num ,
        error: function() {
          alert("服务器内部错误");
        },
        success: function(data){
          if (data == "success") {
            alert('验证码已成功发送至您的手机！如果在3分钟内没有收到短信，请重新点击获取验证码');
            $("#notice").html("提示:验证码已成功发送至您的手机！<br/>如果在3分钟内没有收到短信，请重新点击获取验证码");
            $("#mobile_verify").show(); 
            $("#mobile_button").val("重新发送").removeAttr("disabled");
          }else{
            alert(data);
            $("#notice").text(data);
            $("#mobile_button").val("重新发送").removeAttr("disabled");
            return false;
          };
      }
      });
    }else{
      alert("手机号码不正确,请重新输入.");
      return false;
    };
  });
    
  //每60秒自动保存
  $(document).everyTime('1120s','save_draft',function() {
    if ($("#save_as_draft").attr("disabled") == false && $("#submit_diary").attr("disabled") == false) {
        $("#diary_content_editor").val(CKEDITOR.instances.diary_content_editor.getData());
        $("#diary_form").saveWithAjax(0);
    };
  },0,true);
	
  //暂存为草稿
  $("#save_as_draft").click(function() {
    $("#diary_form").saveWithAjax(0);
  });

  //正式提交
  $("#submit_diary").click(function() {
    validate_diary_city();
    validate_diary_district();
    validate_building_name();
    validate_content();
    validate_picture();
    validate_title();
    validate_company();
    validate_options();
    var numError=$("form .errorFlag").length;
    if (numError>0) {
      if (!$("#picyl").hasClass("errorFlag")) {
        alert(numError+"项内容没有填写,请填写完整再提交");
        $("#select_city_area").attr("style", "");
      };
      return false;
    }else{
      $(document).stopTime();
      $("#diary_status").val("0");
      $("#diary_form").saveWithAjax(1);
    };
    /*
    $(document).stopTime();
    $("#diary_status").val("0");
    $("#diary_form").saveWithAjax(1);
    */
  });

  function validate_content() {
    if ((CKEDITOR.instances.diary_content_editor.getData()).length<15) {
      $("#diary_content_editor").addClass("errorFlag");
      alert("正文内容不能少于15个字！");
    }else{
      $("#diary_content_editor").removeClass("errorFlag");
    };
  };

  //样式控制
  function validate_title(){
    var $title = $("#diary_title")
    if ($title.val().length == 0 ){
      $title.setRed();}else{$title.cleanRed();
    };
  };

  // 验证小区名称是否填写
  function validate_building_name(){
    var $building_name = $("#diary_building_name");
    if ($building_name.val().length == 0)
      $building_name.setRed();
    else
      $building_name.cleanRed();
  }

  // 验证小区所属区域
  function validate_diary_district(){
    var $deco_district = $("#diary_district");
    if($deco_district.val().length == 0)
      $deco_district.setRed();
    else
      $deco_district.cleanRed();
  }

  // 验证小区所属城市
  function validate_diary_city(){
    var $deco_city = $("#diary_city");
    if($deco_city.val().length == 0)
      $deco_city.setRed();
    else
      $deco_city.cleanRed();
  }

  //验证日记所属公司
  function validate_company(){
    var $company = $("#selectproductinput")
    if ($company.val().length == 0 ){
      $company.setRed();
    }else{
      $company.cleanRed();
    };
  };

  //验证4个选项
  function validate_options(){
    $.each($(".option"), function(){     
      if ($(this).val().length == 0) {
        $(this).parent().css("border","2px solid #FF0000");
        $(this).parent().addClass("errorFlag");
      }else{
        $(this).parent().css("color","");
        $(this).parent().removeClass("errorFlag");
      };
   });
  };

  //验图是否有图片
  function validate_picture(){
    if ($("#picyl tr").length < 3) {
      $("#picyl").addClass("errorFlag");
      alert("请至少上传三张图片");
    }else{
      $("#picyl").removeClass("errorFlag");
      if ($(".master:checked").length == 0 && $(".master").length > 1  ) {
        $("#picyl").addClass("errorFlag");
        alert("请指定主图");
        $("#select_city_area").attr("style", "");
      }else{
        if($(".master:checked").length == 0 && $(".master").length == 1){
          $(".master").attr("checked","checked")
        };
        $("#picyl").removeClass("errorFlag");
      $.each($(".space"), function(){     
          if ($(this).val().length == 0) {
            $(this).parent().css("border","2px solid #FF0000");
            $(this).parent().addClass("errorFlag");
          }else{
            $(this).parent().css("border","");
            $(this).parent().removeClass("errorFlag");
          };
        });
      };
    };
  };

  //样式控制
  jQuery.fn.setRed=function(){
    $(this).css("border-color","#FF0000");
    var $tip=$(this).next();
    $tip.addClass("errorFlag");
    $tip.show();
  };
  //控制样式
  jQuery.fn.cleanRed=function(){
    var $tip=$(this).next();
    $(this).css("border-color",'');
    $tip.removeClass("errorFlag");
                      $tip.hide();
  };

  //保存
  jQuery.fn.saveWithAjax = function(button) {	
    var value = $("#save_as_draft").val();
    $("#save_as_draft").attr("disabled","disabled").val("正在保存...");
    $("#submit_diary").attr("disabled","disabled").val("正在保存...");
    $("#diary_content_editor").val(CKEDITOR.instances.diary_content_editor.getData());
    var datas = $("#diary_form").serialize() +"&button=" + button ;
    if (button == 0) {
      var url = '/decoration_diaries/create_draft';
    }else{
      var url = '/decoration_diaries';
    };
    $.ajax({
        type: "POST",
        url: url,
        dataType:"script",
        data: datas ,
        success: function(){
          $("#save_as_draft").removeAttr("disabled").val(value);
          $("#submit_diary").removeAttr("disabled").val("发表日记");
          if (button == 1	&& $("#score").val() != "1") {
              $('select').remove();  
              show_advice_div();
          }else if(button == 1	&& $("#score").val() == "1"){
                  self.location.replace('/decoration_diaries');
          };
        }
      });
    return false;
  };
});



function w(vd)
{
  var ob=document.getElementById(vd);
  if(ob.style.display=="block" || ob.style.display=="")
  {
     ob.style.display="none";
     var ob2=document.getElementById('s'+vd);
  }
  else
  {
    ob.style.display="block";
    var ob2=document.getElementById('s'+vd);
  }
}
function k(vd)
{
  var ob=document.getElementById(vd);  
  if(ob.style.display=="block")
  {
     ob.style.display="none";
     var ob2=document.getElementById('s'+vd);
  }
  else
  {
    ob.style.display="block";
    var ob2=document.getElementById('s'+vd);
  }
}

