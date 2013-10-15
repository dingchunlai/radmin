jQuery(document).ready(function($) {
	//打分评价
	
	$(".big-star p").live('click',function() {
	var star = $(this).parent().attr("data-praise") ;
	switch (star.toString()){
	case "2":
	$("#show_key").text("很不满意");
	break;
	case "4":
	$("#show_key").text("不满意");
	break;
	case "6":
	$("#show_key").text("一般");
	break;
	case "8":
	$("#show_key").text("满意");
	break;
	case "10":
	$("#show_key").text("非常满意");
	break;
	default:
	$("#show_key").text("请评分");
	}
	});
	
	$(".set-praise").html("<p></p><p></p><p></p><p></p><p></p>");
	$(".set-praise p").mouseover(function() {
		
		$(this).addClass("one").prevAll().addClass("one").end().nextAll().removeClass("one");
	}).click(function() {
		var praise = $(this).siblings(".one").length * 2 + 2;
		$(this).parent().attr("data-praise", praise);
	}).parent().mouseout(function() {
		var star = $(this).attr("data-praise")/2 - 1 ;
		
		if (star == -1 ) {
			$(this).children().removeClass("one");
		}else{
			$(this).children(":lt("+star+")").addClass("one").end().
							children(":eq("+star+")").addClass("one").end().
							children(":gt("+star+")").removeClass("one");
		};
		
	});
});
