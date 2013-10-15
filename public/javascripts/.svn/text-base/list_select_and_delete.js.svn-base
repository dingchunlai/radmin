function deleteAll(url){
  var ids = getids();
  if (ids!=""){
	  if (confirm('您确定要删除这些记录吗？')){
	  hideiframe.location = url + "?ids=" + ids;
	  hidden_record(ids);
	  }
  }
}

var checkflag = "false";
function SelectAll(field) { //全选checkbox
  if (checkflag == "false") {
    if (field.length==undefined)
      field.checked = true;
    else
      for (i = 0; i < field.length; i++) field[i].checked = true;
    checkflag = "true";
    return "false";
  }
  else {
    if (field.length==undefined)
      field.checked = false;
    else
      for (i = 0; i < field.length; i++) field[i].checked = false;
    checkflag = "false";
    return "true";
  }
}

function getids(){
    var ids = [];
    if (document.form1.arid.length==undefined){
        if (document.form1.arid.checked) ids = document.form1.arid.value;
    }else{
        for (i=0; i<document.form1.arid.length;i++){
            if (document.form1.arid[i].checked && document.form1.arid[i].value!='0') ids.push(document.form1.arid[i].value);
        }
        ids = ids.join(",");
    }
    if (ids==""){alert("请至少选择1条记录！"); return "";} else return ids;
}

function hidden_record(ids){
  ids = ids.split(",");
  for (var id in ids){
    if (ge('arid' + ids[id])!=null){
      ge('arid' + ids[id]).value = '0';
      ge('tr_' + ids[id]).style.display = "none";
    }
  }
}

//<input onclick="SelectAll(document.form1.arid)" type="button" value="全选" class="btn1_mouseout" onmouseover="this.className='btn1_mouseover'" onmouseout="this.className='btn1_mouseout'" /> 
//<input onclick="deleteAll('/zhuanqu/dantu_del')" type="button" value="批量删除" class="btn1_mouseout" onmouseover="this.className='btn1_mouseover'" onmouseout="this.className='btn1_mouseout'" />