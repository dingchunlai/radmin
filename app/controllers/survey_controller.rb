class SurveyController < ApplicationController
  #外网查看调查
  def preview
    @columns = Column.find :all,
    :select => "id, sn, cname, ctype, ovalue, dvalue, remark, mustfill",
    :conditions => "formid = #{params[:id]}",
    :order => "sn asc"
    @form = Form.find(params[:id])
    render :layout => false
  end
  
  #保存并且跳转查看结果页
  def survey_save
    if pp(params[:formid])
      fd = Fdata.new
      fd.formid = params[:formid].to_i
      fd.userip = request.remote_ip
      fd.cdate = getnow
      fd.udate = getnow
      1.upto(30) do |i|
        file = eval("params[:c#{i}]")
        if file.type!=String && file.type!=Array && file!=nil
        else
          #如果是普通的表单对象
          eval("fd.c#{i} = fp(params[:c#{i}]) if pp(params[:c#{i}])")
        end
      end
      fd.save
      
#      #投票满10次统计1下
#      key = "key_20090723_suvery_count_#{params[:formid]}"
#
#      if CACHE.get(key).nil? || CACHE.get(key).to_s == '10'
#        Countresult.dosurveycount(params[:formid].to_i)
#        CACHE.set(key,'0') 
#      else
#        CACHE.set(key,CACHE.get(key).to_i+1) 
#      end
      
      Countresult.dosurveycount(params[:formid].to_i)
      if params[:type] && params[:type] == '2'
        redirect_to :action => "survey_result2",:formid => params[:formid]
      else
        redirect_to :action => "survey_result",:formid => params[:formid]
      end
    end
  end
  
  #查看调查结果
  def survey_result
    formid = params[:formid]
    @form = Form.find(formid)
    
    @result = Countresult.getsurveyresult(formid)
    @count = Countresult.find_by_sql("select count(1) as c from radmin_fdatas where formid = '#{formid}'")[0].c   
  end
  
  #查看调查结果(产品头部)
  def survey_result2
    formid = params[:formid]
    @form = Form.find(formid)
    
    @result = Countresult.getsurveyresult(formid)
    @count = Countresult.find_by_sql("select count(1) as c from radmin_fdatas where formid = '#{formid}'")[0].c   
  end
end
