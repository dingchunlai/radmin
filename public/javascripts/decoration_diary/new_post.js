jQuery(document).ready(function($) {
  
    function validate_content_length() {
         $("#post_content_editor").val(KE.html("post_content_editor"));
        if ($("#post_content_editor").val().length < 20) {
            alert("不能少于20字.");
            $("#post_content_editor").addClass("error_tip");
        }else{
            $("#post_content_editor").removeClass("error_tip");
        };
    };
    function validate_picture_space() {
        $.each($(".space"), function(){
            if ($(this).val() == "请选择") {
                if (!$(this).hasClass("errorFlag")) {
                    $(this).addClass("errorFlag").after("<span class='error_tip'><img src='http://js.51hejia.com/img/icons/alert.gif'/>必选</span>");
                };
            }else{
                $(this).removeClass("errorFlag").next(".error_tip").remove();
            };
        });
    };
   
    $('#post_form').submit(function() {
        $('#post_submit').attr("disabled","disabled");
        validate_content_length();
        validate_picture_space();
        if ($(".error_tip").length>0) {
            $('#post_submit').removeAttr("disabled");
            return false;
        }else{
            $.ajax({
                url: $('#post_form').attr("action"),
                type: $("#post_form").attr("data-type"),
                dataType: 'json',
                data: $("#post_form").serialize(),
                success: function(data) {
                    if (data.message == "update_success") {
                        alert("日记更新成功!");
                        self.location.replace('/decoration_diaries/'+data.decoration_diary_id);
                    }else{
                        var myData = {
                            body: data.body,
                            created_at: data.created_at,
                            id: data.id
                        };
                        $( "#post_li" ).tmpl(myData).hide().prependTo("#posts_ul").slideDown();
                        reset_form();
                        alert("日记发表成功!");
                        if($.cookie('redis_cookie_is') || $.cookie('dont_remind_me')){
                        }else{
                        $(".zx_diarytancbg").show();
                        $(".zx_diarytancbox").show();
                        };
                    };
                },
                error: function(xhr, textStatus, errorThrown) {
                    $('#post_submit').removeAttr("disabled");
                    alert(errorThrown);
                }
            });
        };
        return false;
    });
  
  
    // 上传图预览
    $('.preview_pic').live("mouseover",function() {
        // alert("on");
        $(this).next().show();
    }).live("mouseout",function() {
        $(this).next().hide();
    });
  
    // 重置表单
    function reset_form() {
        KE.html("post_content_editor","");
        $('#picyl tbody tr').remove();
        $('#post_submit').removeAttr("disabled");
    };
  
    // 删除post
    $('.delete_post').live("click", function() {
        var $li = $(this).parents("li");
        if(confirm("确认删除?")){
            $.ajax({
                url: '/decoration_diary_posts/' + $li.attr("data-post-id") ,
                type: 'DELETE',
                dataType: 'json',
                success: function(data) {
                    $li.remove();
                },
                error: function(xhr, textStatus, errorThrown) {
                    alert("服务器错误")
                }
            });
            return false;
        }
    });

    // 更改post的state(审核、取消审核)
    $('.update_post_state').live("click", function() {
        var $li = $(this).parents("li");
        $.post('/decoration_diary_posts/update_post_state',{
            'post_id': $li.attr("data-post-id")
        },function(data){
            if(data == "true"){
                alert('操作已成功');
                window.location.reload();
            }else{
                alert('操作失败');
            }
        }
        );
        return false;
    });
  
    // 打分的区域
    $('.best, .better').click(function() {
        $(this).siblings().removeAttr("checked");
    
    });
    $('.best').click(function() {
        var i = $('.best').index($(this));
        $('.better:eq('+i+')').removeAttr("checked").attr("disabled",true).siblings().removeAttr("disabled");
    });
  
    $('.better').click(function() {
        var i = $('.best').index($('.best:checked'));
        var j = $('.better').index($('.better:checked'));
        if (i>=0 && j >=0 ) {
            $('.good').val(8);
        };
    });
  
    // 打分表单提交
    $('#score_form').submit(function() {
        var praise = $('#praise_div').attr("data-praise");
        if (praise == 0 || $('#content').val().length == 0) {
            alert("请在评分并留言后再提交!");
            return false;
        };
    
        $('#praise').val(praise);
        $.ajax({
            url: $(this).attr("action"),
            type: 'POST',
            dataType: 'json',
            data: $("#score_form").serialize(),
            success: function(data) {
                if (data == "success") {
                    alert("打分提交成功.")
                    $('#score_form').remove();
                }else{
                    alert("3个月内只能打一次分数");
                };
            },
            error: function(xhr, textStatus, errorThrown) {
                alert("服务器内部错误,请稍后再试")
            }
        });
    
        return false;
    });
  
});
