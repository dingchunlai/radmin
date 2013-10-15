
function $G(Read_Id) { return document.getElementById(Read_Id) }
function Effect(ObjectId,parentId){
var Obj_Display = $G(ObjectId).style.display;
	if (Obj_Display == 'none'){
	Start(ObjectId,'Opens');
	$G(parentId).innerHTML = "<a href=# onClick=javascript:Effect('"+ObjectId+"','"+parentId+"');>7月和家网友招募行动，填写以下信息，即可参加！（仅限上海地区）</a>"
	}else{ 
	Start(ObjectId,'Close');
	$G(parentId).innerHTML = "<a href=# onClick=javascript:Effect('"+ObjectId+"','"+parentId+"');>7月和家网友招募行动，填写以下信息，即可参加！（仅限上海地区）</a>"
	}
}
function Start(ObjId,method){
var BoxHeight = $G(ObjId).offsetHeight;   			//获取对象高度
var MinHeight = 5;									//定义对象最小高度
var MaxHeight = 400;					 			//定义对象最大高度
var BoxAddMax = 1;									//递增量初始值
var Every_Add = 0.99;								//每次的递(减)增量  [数值越大速度越快]
var Reduce    = (BoxAddMax - Every_Add);
var Add       = (BoxAddMax + Every_Add);
//关闭动作**************************************
if (method == "Close"){
var Alter_Close = function(){						//构建一个虚拟的[递减]循环
	BoxAddMax /= Reduce;
	BoxHeight -= BoxAddMax;
	if (BoxHeight <= MinHeight){
		$G(ObjId).style.display = "none";
		window.clearInterval(BoxAction);
	}
	else $G(ObjId).style.height = BoxHeight;
}
var BoxAction = window.setInterval(Alter_Close,1);
}
//打开动作**************************************
else if (method == "Opens"){
var Alter_Opens = function(){
	BoxAddMax *= Add;
	BoxHeight += BoxAddMax;
	if (BoxHeight >= MaxHeight){
		$G(ObjId).style.height = MaxHeight;
		window.clearInterval(BoxAction);
	}else{
	$G(ObjId).style.display= "block";
	$G(ObjId).style.height = BoxHeight;
	}
}
var BoxAction = window.setInterval(Alter_Opens,1);
}
}







	<!--
		var obj;
		function list(meval)
		{
			var left_n=eval(meval);
			
			if (left_n.style.display=="none")
			{ eval(meval+".style.display='';");
			if (obj!=null && obj!=meval){eval(obj+".style.display='none';");
			}obj=meval;
			}
			else
			{ eval(meval+".style.display='none';"); }
			//scroll
			var newobj=document.getElementById("list_bill");
			height=newobj.scrollTop;
			newobj.scrollTop=(event.y>70)?height+30:height-30;
		}
	//-->

<!--
		var obj;
		function lista(meval)
		{
			var left_n=eval(meval);
			
			if (left_n.style.display=="none")
			{ eval(meval+".style.display='';");
			if (obj!=null && obj!=meval){eval(obj+".style.display='none';");
			}obj=meval;
			}
			else
			{ eval(meval+".style.display='none';"); }
			//scroll
			var newobj=document.getElementById("list_billa");
			height=newobj.scrollTop;
			newobj.scrollTop=(event.y>70)?height+30:height-30;
		}
	//-->

<!--
		var obj;
		function listb(meval)
		{
			var left_n=eval(meval);
			
			if (left_n.style.display=="none")
			{ eval(meval+".style.display='';");
			if (obj!=null && obj!=meval){eval(obj+".style.display='none';");
			}obj=meval;
			}
			else
			{ eval(meval+".style.display='none';"); }
			//scroll
			var newobj=document.getElementById("list_bill2");
			height=newobj.scrollTop;
			newobj.scrollTop=(event.y>70)?height+30:height-30;
		}
	//-->

