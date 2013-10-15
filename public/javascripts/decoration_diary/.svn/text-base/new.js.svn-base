//jQuery.extend(jQuery.validator.messages, {
//    required: ' '
//});
jQuery(document).ready(function($) {
  // 城市选择插件
//  $('#province_city_select').CitySelectTag({
//    province_name: "decoration_diary[city]" ,
//    city_name: "decoration_diary[district]",
//    city_include_blank: true
//  });

//通过省/市，选择市/区
$("#decoration_diary_city").click(function(){
    var city = $("#decoration_diary_city").val();
    $.post("/decoration_diaries/select_city_area",{"cityid":city},function(data){
        $("#select_city_area").html(data);
    })
})
  
  // 选择公司的autocomplete
  $("#deco_firm_name").autocomplete({
    source:"/deco_firms/name_list",
    minLength: 1,
    delay: 2000
  });
  
  $("#deco_firm_name").keyup(function() {
    $(this).autocomplete("search",$(this).val());
  });
  
  $("#deco_firm_name").click(function() {
    $('.ui-autocomplete').show();
  });
  
  // 手机号验证
  function isRightMobileNumber(s){
    var patrn=/^0?1(4\d|3\d|5[012356789]|8[0123456789])\d{8}$/;
    if (!patrn.exec(s)) return false
    return true
  }
	
  $("#mobile_verify").click(function() {
    var code = $("#code").val();
    var mobile = $("#mobile").val();
    $.ajax({
      type: "POST",
      url: "/user/verify_mobile_code",
      dataType:"json",
      data: "&code="+code+"&mobile="+mobile ,
      success: function(data){
        if (data==1) {
          $("#mobile_verify_wrapper").html("已通过手机验证!").addClass("passed");
          $('#notice').html("");
        }else{
          alert("验证码错误,请重新输入.")
        };
    }
    });
  });
	
  $("#send_sms").click(function() {
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
            $("#notice").html("提示:验证码已成功发送至您的手机！如果在3分钟内没有收到短信，请重新点击获取验证码");
           // $("#mobile_verify").show(); 
            $("#send_sms").val("重新发送").removeAttr("disabled");
          }else{
            alert(data);
            $("#notice").text(data);
            $("#send_sms").val("重新发送").removeAttr("disabled");
            return false;
          };
      }
      });
    }else{
      alert("手机号码不正确,请重新输入.");
      return false;
    };
  });
  
  // 关于日记的验证
  $('#diary_form').validate({
    onfocusout: function(element) {
      if( !$(element).hasClass('no-onfocusout-validation') ) $.validator.defaults.onfocusout.call(this, element);
    },
    rules: {
        deco_firm_name: {
          required: true,
          remote: {
            url: "/decoration_diaries/get_deco_firm_id",
            data: {
              deco_firm_name: function() {
                return $("#deco_firm_name").val();
              }
            }
          }
        }
      },
    messages: {
        deco_firm_name: {
          remote: "没有"
        },
        title:{
            required: ""
        }
    }
  });
  
  $('#diary_form').submit(function() {
    if (!$('#mobile_verify_wrapper').hasClass("passed") ) {
      alert("请先进行手机验证再发表日记");
      return false;
    };
    
  
    
    
    
  });
});
