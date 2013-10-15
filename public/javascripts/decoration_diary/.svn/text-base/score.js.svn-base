
	function show_advice_div(){
		$(".should_hide").hide();
    document.getElementById('popDiv').style.display='block';
    document.getElementById('popIframe').style.display='block';
    document.getElementById('bbg').style.display='block';
    var adv = document.getElementById("advice_div"),
        btn = document.getElementById('advice_form_submit');
    if(btn && btn.disabled) btn.disabled = false;
        document.getElementById("ad_context").focus();
					//打分
					$("#remark_form").submit(function() {

						$("#praise").attr("value",$("#praise_div").attr("data-praise"));
						$("#design_praise").attr("value",$("#design_praise_div").attr("data-praise"));
						$("#construction_praise").attr("value",$("#construction_praise_div").attr("data-praise"));
						$("#service_praise").attr("value",$("#service_praise_div").attr("data-praise")) ;
						if ($("#remark_form textarea").val().length == 0) {
							alert("留言不能为空");
							return false;
						}else{
							if ($("#praise_div p.one").length == 0) {
								alert("请打分");
								return false;
							}else{
								$("#advice_form_submit").attr("disabled","disabled").val("正在保存...");
							};
						};
					});

	}
	
	function closeDiv(){
	document.getElementById('popDiv').style.display='none';
	document.getElementById('bg').style.display='none';
	document.getElementById('popIframe').style.display='none';
	document.getElementById("is_q_a").value = 1;
}

