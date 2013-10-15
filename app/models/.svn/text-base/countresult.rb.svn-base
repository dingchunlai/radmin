# == Schema Information
#
# Table name: countresults
#
#  id          :integer(11)     not null, primary key
#  form_id     :integer(11)
#  form_type   :integer(11)
#  obj_id      :integer(11)
#  obj_type    :integer(11)
#  description :string(255)
#  itemnum     :integer(11)
#  c_1         :string(255)
#  c_2         :string(255)
#  c_3         :string(255)
#  c_4         :string(255)
#  c_5         :string(255)
#  c_6         :string(255)
#  c_7         :string(255)
#  c_8         :string(255)
#  c_9         :string(255)
#  c_10        :string(255)
#  c_11        :string(255)
#  c_12        :string(255)
#  c_13        :string(255)
#  c_14        :string(255)
#  c_15        :string(255)
#  s_1         :string(255)
#  s_2         :string(255)
#  s_3         :string(255)
#  s_4         :string(255)
#  s_5         :string(255)
#  s_6         :string(255)
#  s_7         :string(255)
#  s_8         :string(255)
#  s_9         :string(255)
#  s_10        :string(255)
#  s_11        :string(255)
#  s_12        :string(255)
#  s_13        :string(255)
#  s_14        :string(255)
#  s_15        :string(255)
#

class Countresult < ActiveRecord::Base
  #评论性表单统计
  def self.docount(form_id,form_type,obj_id,obj_type)
    
    form = Form.find(form_id)
    description = form.title    #描述
    
    columnsneedcount = Column.find(:all,:conditions => "formid='#{form_id}' and sep_type ='1' and sep_value is not null ",:order => "id desc")
    size = columnsneedcount.size     #统计数
    
    c = ['','','','','','','','','','','','','','','']
    s = ['','','','','','','','','','','','','','','']
    
    #手动插入
    str = "insert into countresults (form_id,form_type,obj_id,obj_type,description,itemnum,c_1,c_2,c_3,c_4,c_5,c_6,c_7,c_8,c_9,c_10,c_11,c_12,c_13,c_14,c_15,s_1,s_2,s_3,s_4,s_5,s_6,s_7,s_8,s_9,s_10,s_11,s_12,s_13,s_14,s_15) "
    str = str + " values ( '#{form_id}','#{form_type}','#{obj_id}','#{obj_type}','#{description}','#{size}' "
    
    #循环处理数据 统计项目名放入c[]分数放入s[]
    
    colindex = 0
    columnsneedcount.each do |col|
      
      c[colindex] = col.cname #统计项目名
      
      col.sep_value           #特殊处理1,2,3,4|0.25,0.25,0.25,0.25格式
      
      arr = col.sep_value.split('|')
      items = arr[0].split(',')
      times = arr[1].split(',')
      
      result = 0
      indexnum = 0
      
      #分数计算
      items.each do |item|
        result = result + getavgscorenotround(form_id,"c#{item}").to_s.to_f * times[indexnum].to_s.to_f
        indexnum = indexnum + 1
      end
      
      s[colindex] = result.round #分数
      
      colindex = colindex + 1
    end
    
    #拼sql
    c.each do |cc|
      str = str + ",'#{cc}'"
    end
    s.each do |ss|
      str = str + ",'#{ss}'"
    end    
    str = str + ')'
    
    find_by_sql "delete from countresults where form_id = '#{form_id}' and form_type = '#{form_type}' and obj_id = '#{obj_id}' and obj_type = '#{obj_type}'" rescue ''
    find_by_sql str rescue ''
    
  end
  
  def self.getavgscorenotround(form_id,keyword) 
    str = "select avg(#{keyword}) as c from radmin_fdatas where formid = '#{form_id}' "
    find_count = find_by_sql(str)[0].c
    return find_count    
  end
  
  #获得所有项目名
  def self.getitemnames(obj_id,obj_type)
    results = [] 
    
    result = find(:first,:conditions => "obj_id = '#{obj_id}' and obj_type = '#{obj_type}'")
    if result
      cresult = [result.c_1,result.c_2,result.c_3,result.c_4,result.c_5,result.c_6,result.c_7,result.c_8,result.c_9,result.c_10,result.c_11,result.c_12,result.c_13,result.c_14,result.c_15]
      
      for i in 0..result.itemnum do  
        results << cresult[i]          
      end
    end
    return results
  end
  
  #获得所有分数
  def self.getitemvalues(obj_id,obj_type)
    results = []
    
    result = find(:first,:conditions => "obj_id = '#{obj_id}' and obj_type = '#{obj_type}'")
    if result
      sresult = [result.s_1,result.s_2,result.s_3,result.s_4,result.s_5,result.s_6,result.s_7,result.s_8,result.s_9,result.s_10,result.s_11,result.s_12,result.s_13,result.s_14,result.s_15]
      
      for i in 0..result.itemnum do  
        results << sresult[i]          
      end
    end
    return results 
  end
  
  #调查统计
  def self.dosurveycount(form_id)
    columns = Column.find(:all,:conditions => "formid='#{form_id}' and  (ctype = '1' or ctype = '2') ",:order => "id asc")
    
    str = "delete from countresults where form_id = '#{form_id}' and form_type = '#{2}' "
    find_by_sql str rescue ''
    
    #需要统计的字段
    if columns
      columns.each do |col| 
        temprecord = Countresult.new
        chooses_str = []      #答案数组
        chooses_num = []      #选择数数组
        percent_num = []      #百分比数组
        keyword = col.sn
        
        temprecord.form_id=form_id
        temprecord.form_type=2    #调查类
        temprecord.obj_id=col.id
        temprecord.obj_type=2     #对象为column
        temprecord.description=col.cname
        
        
        if col.ovalue
          chooses_str = col.ovalue.split(',')
        end
        
        sum = 0               #总数
        chooses_str.each do |cs|
          tempnum = getavgscorenotround(form_id,"c#{keyword}",cs)
          chooses_num << tempnum
          sum = sum+tempnum.to_i
        end
        
        i = 1  
        chooses_num.each do |num|
          percent = ((num.to_i*1000/sum).round).to_f/10
          percent = 0 if percent == 0.0
          eval("temprecord.c_#{i} = chooses_str[#{i-1}]")
          eval("temprecord.s_#{i} = #{percent}")
          i = i + 1
        end
        
        temprecord.itemnum = chooses_str.size
        
        temprecord.save
                
      end
    end
  end
  
  #统计单个
  def self.getavgscorenotround(form_id,keyword,choose) 
    str = "select count(1) as c from radmin_fdatas where formid = '#{form_id}' and #{keyword} like '%#{choose}%'"
    find_count = find_by_sql(str)[0].c
    return find_count    
  end
  
  #获得调查结果
  def self.getsurveyresult(form_id)
    surveyresults = []
    
    #该调查统计表数据
    counts = find(:all,:conditions => "form_id = '#{form_id}'",:order => "id asc")
    
    counts.each do |count|
      #一题的统计数据
      single = []
      
      #题目
      description = count.description   
      
      num = count.itemnum #有多少选择
      #选择统计
      answers = []
      1.upto(num.to_i) do |i|
        answers << eval("count.c_#{i}")
      end
      
      #百分比统计
      percents = []
      1.upto(num.to_i) do |i|
        percents << eval("count.s_#{i}")
      end
            
      single << description
      single << answers
      single << percents
      
      #所有记录
      surveyresults << single
    end
    
    return surveyresults
  end
end
