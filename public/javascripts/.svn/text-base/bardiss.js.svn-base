 
$(document).ready(function() {
 		var seconds = 60, minute = 0, second = 0;
	 $("#second").everyTime('1s',function() {
		seconds -- ;
		if(seconds<0) {
			$("#submit_button").attr("disabled","disabled");
			if(confirm("很遗憾，您的时间已经用完！点击'确定'再来一次，点击'取消'返回主页。")){
				 self.location.replace('/huodong/bardiss/timeout?retry=true');
				 return false;
				}else{
				self.location.replace('/huodong/bardiss/timeout');
				return false;
				} 
		}else{
//			minute = Math.floor(seconds / 60);
//			second = seconds % 60;
//			$("#minute").text(minute);
			$("#second").text(seconds);
		}
	 });
	 $("form").submit(function() {
	 	$("#submit_button").attr("disabled","disabled");
	 	$("#second").stopTime();
	 	$("#spent_time").val(60-seconds);
		return true;
	 });
});