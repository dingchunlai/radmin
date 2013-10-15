# == Schema Information
#
# Table name: 51hejia.radmin_fdatas
#
#  id       :integer(11)     not null, primary key
#  formid   :integer(11)     not null
#  userip   :string(15)
#  status   :integer(4)      default(0), not null
#  isdelete :(1)             default("\000"), not null
#  cdate    :datetime
#  udate    :datetime
#  ptime    :datetime
#  c1       :string(512)
#  c2       :string(512)
#  c3       :string(512)
#  c4       :string(512)
#  c5       :string(512)
#  c6       :string(512)
#  c7       :string(512)
#  c8       :string(512)
#  c9       :string(512)
#  c10      :string(512)
#  c11      :string(512)
#  c12      :string(512)
#  c13      :string(512)
#  c14      :string(512)
#  c15      :string(512)
#  c16      :string(512)
#  c17      :string(512)
#  c18      :string(512)
#  c19      :string(512)
#  c20      :string(127)
#  c21      :integer(11)
#  c22      :integer(11)
#  c23      :integer(11)
#  c24      :integer(11)
#  c25      :integer(11)
#  c26      :integer(11)
#  c27      :integer(11)
#  c28      :integer(11)
#  c29      :integer(11)
#  c30      :text
#  remark   :string(512)
#  area     :string(8)
#  c31      :integer(11)
#  c32      :integer(11)
#  c33      :integer(11)
#  c34      :integer(11)
#  c35      :integer(11)
#

class DecoReview < ActiveRecord::Base
  self.table_name = "51hejia.radmin_fdatas"
  
  require '_generate'
  
  alias_attribute :company_id, :c1                #公司id
  alias_attribute :user_id, :c2                   #评论人id
  alias_attribute :design_score, :c3              #设计分
  alias_attribute :budget_score, :c4              #预算分
  alias_attribute :construction_score, :c5        #施工分
  alias_attribute :service_score, :c6             #服务分
  alias_attribute :complex_score, :c7             #综合分
  alias_attribute :title, :c8                     #标题
  alias_attribute :vip, :c9                       #后台录入
  alias_attribute :content, :c30                  #评论内容    
  alias_attribute :flower_num, :c10               #鲜花数
  alias_attribute :response_num, :c11             #回应数
  alias_attribute :report_num, :c12               #举报数
  alias_attribute :area, :c13                     #装修小区
  alias_attribute :address, :c14                  #小区地址
  alias_attribute :review_type, :c15              #评论类型 1:普通 2：精华 3：投诉
  alias_attribute :username, :c16                 #后台直接输入用户名
  alias_attribute :userurl, :c17                  #用户头像
  alias_attribute :author, :c18                   #录入人
  alias_attribute :phone, :c19                    #联系方式
  alias_attribute :photourl, :c20                 #图片路径
  alias_attribute :price, :c23                    #装修价格
  alias_attribute :method, :c21                   #装修方式
  alias_attribute :style, :c22                    #装修风格
  alias_attribute :review_type2, :c24             #评论类型2 0:业主博客 1：编辑抽查 2：小编看公司 3:创作案例
  alias_attribute :main_id, :c25                  #主日记id
  alias_attribute :city_id, :c26                  #城市id
  alias_attribute :district_id, :c27              #地区id
  alias_attribute :stage, :c28                    #装修阶段
  alias_attribute :room, :c29                     #房型            
  alias_attribute :dpv, :c32                      #点评PV
  alias_attribute :back_author_id, :c33           #后台录入人id
  alias_attribute :good, :c35                     #1荣誉，2血泪史
  alias_attribute :egg, :c31                      #臭鸡蛋
  belongs_to :company,
  :class_name => "DecoFirm",
  :foreign_key => "c1"
  
  SCORECLASS = [ 
  [0.01,10,-1,1],
  [10,20,-1,2],
  [20,30,-1,3],
  [30,50,-1,3.5],
  [50,100,30,4],
  [100,200,20,4.5],
  [200,9999,10,5]
  ]
  
  STARDATE = '2009-12-03'
  
  def self.update_this_adjusted_score
    
  end
  
  #现在还不能删除 update_adjusted_score ,如果7月份还看到这玩意,说明我忘记删除了,请帮忙删除
  def self.update_adjusted_score(companyid,design_score = 0,budget_score = 0,construction_score = 0,service_score = 0)
#    @company = DecoFirm.find(companyid)
#    adjusted_score = @company.adjusted_score
#    total_score = design_score  + budget_score + construction_score + service_score
    total_score_new = design_score  + budget_score + construction_score + service_score
#    if total_score > 0
#      design_score = design_score * (1+ adjusted_score/total_score)
#      budget_score = budget_score * (1+ adjusted_score/total_score)
#      construction_score = construction_score * (1+ adjusted_score/total_score)
#      service_score = service_score * (1+ adjusted_score/total_score)
#    end
    #@company.save

    DecoFirm.update_all("design_score_new = #{design_score} , budget_score_new = #{budget_score} ,
                          construction_score_new = #{construction_score} ,service_score_new = #{service_score} ,
                         total_score_new = #{total_score_new} ",:id => companyid )
  end
  
  #根据提供的公司id进行统计工作
  def self.countcompany(formid,companyid)
    company = DecoFirm.find(companyid)
    
    #    score = countavgscore(formid,companyid)
    #    
    #    #5种分数
    #    company.design_score = score[:design_score] #countavgscorebymonth(formid,companyid,'c3') #
    #    company.budget_score = score[:budget_score] #countavgscorebymonth(formid,companyid,'c4') #
    #    company.construction_score = score[:construction_score] #countavgscorebymonth(formid,companyid,'c5') #
    #    company.service_score = score[:service_socre] #countavgscorebymonth(formid,companyid,'c6') #
    #    company.total_score = score[:complex_score] #countavgscorebymonth(formid,companyid,'c7') #
    #    
    #    #3种满意度统计
    #    company.verysatisfied = countreview(formid,companyid,3,5.1)
    #    company.satisfied = countreview(formid,companyid,2,3)
    #    company.unsatisfied = countreview(formid,companyid,0,2)
    
    #5种分数
    score = countsumscore(formid,companyid)
   # company.design_score = score[:design_score] 
  #  company.budget_score = score[:budget_score] 
  #  company.construction_score = score[:construction_score] 
  #  company.service_score = score[:service_socre] 
  #  company.total_score = score[:complex_score] 
    
    #5种分数新算法
    #统计积分排序
     cal_commonts_by_companyid2(company.id,company)
    #    cal_commonts_by_companyid(company.id)
    #3种满意度统计
    company.verysatisfied = countreview(formid,companyid,2,5)
    company.satisfied = countreview(formid,companyid,0,2)
    company.unsatisfied = countreview(formid,companyid,-4,0)
    
    company.comments_count = company.verysatisfied + company.satisfied + company.unsatisfied  #共多少评论
    company.designers_count = countdesigner(companyid) #设计师数
    company.cases_count = countcase(companyid) #案例数
    company.worksites_count = countworksite(companyid) #在建工地数
    
    
    company.digest_comments_count = countreviewbytype(formid,companyid,2) #精华数
    company.latest_comments_count = countreviewbytype(formid,companyid,1) #普通数
    company.complaint_comments_count = countreviewbytype(formid,companyid,3) #投诉数
    
    #公司特色
    if company.comments_count > 0
      company.pricetese = countprice(companyid,formid)
      company.methodtese = countmethod(companyid,formid)
      company.styletese = countstyle(companyid,formid)
    end
    
    company.photos_count = count_photo(companyid)
    company.star = get_star_score(company).to_f
    company.save
    
  end
  
  #新版统计
  def self.countcompany2_bak(formid,companyid)
    company = DecoFirm.find(companyid)
    
    #现在计算总分
    score = countsumscore(formid,companyid)
    
    #5种分数
    #company.design_score = score[:design_score] 
    #company.budget_score = score[:budget_score] 
    #company.construction_score = score[:construction_score] 
    #company.service_score = score[:service_socre] 
    #company.total_score = score[:complex_score] 
    
    #3种满意度统计
    company.verysatisfied = countreview(formid,companyid,2,5)
    company.satisfied = countreview(formid,companyid,0,2)
    company.unsatisfied = countreview(formid,companyid,-4,0)
    
    company.comments_count = company.verysatisfied + company.satisfied + company.unsatisfied  #共多少评论
    company.designers_count = countdesigner(companyid) #设计师数
    company.cases_count = countcase(companyid) #案例数
    company.worksites_count = countworksite(companyid) #在建工地数
    
    company.digest_comments_count = countreviewbytype(formid,companyid,2) #精华数
    company.latest_comments_count = countreviewbytype(formid,companyid,1) #普通数
    company.complaint_comments_count = countreviewbytype(formid,companyid,3) #投诉数
    
    #所谓公司特色
    company.pricetese = countprice(companyid,formid)
    company.methodtese = countmethod(companyid,formid)
    company.styletese = countstyle(companyid,formid)
    
    company.photos_count = count_photo(companyid)
    
    company.save
    

  end
  
  
  def self.count_photo(companyid)
    return DecoPhoto.count("id",:conditions => "entity_id = '#{companyid}'")
  end
  
  #计算确认，未确认数
  def self.countreviewnum(formid,companyid,status)
    conditions = " formid = '#{formid}' and c1 = '#{companyid}' "
    conditions = conditions + "and status = '1' " if status == 1
    conditions = conditions + "and status <> '1' " if status == 0
    return DecoReview.count("id",:conditions => conditions)
  end
  
  #计算设计平均分
  def self.countavgscore(formid,companyid)
    result = DecoReview.find(:all,
                             :select => "round(avg(c3),2) as design_score,round(avg(c4),2) as budget_score,round(avg(c5),2) as construction_score,round(avg(c6),2) as service_socre,round(avg(c7),2) as complex_score",
    :conditions => "status = '1' and formid='#{formid}' and c1='#{companyid}' ").first
    return result
  end   
  
  #计算设计平均分2
  def self.countsumscore(formid,companyid)
    result = DecoReview.find(:all,
                             :select => "sum(c3) as design_score,sum(c4) as budget_score,sum(c5) as construction_score,sum(c6) as service_socre,sum(c7) as complex_score",
    :conditions => "status = '1' and formid='#{formid}' and c1='#{companyid}' ").first
    return result
  end   
  
  #按月份计算平均分 
  def self.countavgscorebymonth(formid,companyid,countcolumn)
    ms = Time.now.to_i
    ms = ms - 30*24*60*60
    time = Time.at(ms)  #一个月前时间
    
    score =  (DecoReview.find(:all,:select => "sum(#{countcolumn}) as c",:conditions=>"status = '1' and formid='#{formid}' and c1='#{companyid}' and cdate>#{time.strftime('%Y%m%d')}").first)[:c]
    num = DecoReview.count("id",:conditions=>"status = '1' and formid='#{formid}' and c1='#{companyid}' and cdate>#{time.strftime('%Y%m%d')}")
    
    return 0 if num == 0
    
    #基数
    all = num.to_i 
    all = 3 if num.to_i<3
    
    #保留统计结果两位小数
    result = score.to_f/all
    
    result = result * 100
    
    result = result.round
    
    result = result.to_f/100
    
    
    return result
  end 
  
  #按公司,等级计算评论数
  def self.countreview(formid,companyid,beginscore,endscore)
    str = "select count(1) as c from radmin_fdatas where c1 = '#{companyid}' and formid='#{formid}' and status='1' and c7+0 >= #{beginscore} and c7+0 < #{endscore}"
    return find_by_sql(str)[0].c
  end
  
  #按公司计算评论数
  def self.countallreview(formid,companyid)
    str = "select count(1) as c from radmin_fdatas where c1 = '#{companyid}' and formid='#{formid}' and status='1' "
    return find_by_sql(str)[0].c  
  end
  
  #按照公司，类型计算评论数
  def self.countreviewbytype(formid,companyid,reviewtype)
    str = "select count(1) as c from radmin_fdatas where c1 = '#{companyid}' and formid='#{formid}' and status='1' and  c15 = '#{reviewtype}'"
    return find_by_sql(str)[0].c  
  end
  
  #设计师数
  def self.countdesigner(companyid)
    return DecoDesigner.count("id",:conditions=>"STATUS <> '-100' and COMPANY = '#{companyid}'")
  end
  
  #案例数
  def self.countcase(companyid)
    return DecoCase.count("id",:conditions=>"COMPANYID = '#{companyid}' and STATUS <> '-100' and ISCOMMEND='0' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1'")
  end
  
  #在建工地
  def self.countworksite(companyid)
    return DecoFactory.count("id",:conditions=>"COMPANYID = '#{companyid}' and #{Time.now.strftime('%Y%m%d')} < ENDENABLE ")
  end
  
  #计算价格--特色：排名第一项
  def self.countprice(companyid,formid)
    result = countsinglecolumn(companyid,formid,'c23',5)
    sortresult = quick_sort_result(result)
    return nil if sortresult[0].to_i == 0
    idx = 1
    result.each do |r|
      if r.to_i == sortresult[0].to_i
        break
      end
      idx = idx + 1
    end
    return idx.to_s
  end
  
  #计算方式--特色:排名前两项
  def self.countmethod(companyid,formid)
    result = countsinglecolumn(companyid,formid,'c21',4)
    sortresult = quick_sort_result(result)
    
    return nil if sortresult[0].to_i == 0
    str = ''
    idx = 1
    result.each do |r|
      if r.to_i == sortresult[0].to_i
        break
      end
      idx = idx + 1
    end
    str = idx.to_s
    result[idx-1] = -1
    
    return str if sortresult[1].to_i == 0
    idx = 1
    result.each do |r|
      if r.to_i == sortresult[1].to_i
        break
      end
      idx = idx + 1
    end
    str = str + ',' + idx.to_s
    
    return str    
  end
  
  #计算风格--特色：有选择即为特色
  def self.countstyle(companyid,formid)
    result = countsinglecolumn(companyid,formid,'c22',6)
    str = '0'
    idx = 1
    result.each do |r|
      str = str + ',' + idx.to_s if r >0
      idx = idx + 1
    end
    
    return str
  end
  
  #计算某公司的单独评论反馈项，返回结果集数组
  def self.countsinglecolumn(companyid,formid,column,num)
    result = []
    1.upto(num) do |i|
      str = "select count(1) as c from radmin_fdatas where c1 = '#{companyid}' and formid='#{formid}' and status='1' and #{column} = '#{i}'"
      result << find_by_sql(str)[0].c.to_i
    end
    
    return result
  end
  
  #排序--具体细节(返回字符串)
  def self.quick_sort(list)
    return list.to_s if list.size<2
    x,*xs = list
    s,b = xs.partition { |e| e<x }
    str = quick_sort(b)+","+[x].to_s+','+quick_sort(s)
    return str
  end
  
  #排序(返回数组)
  def self.quick_sort_result(list)
    str = quick_sort(list)
    strarr = str.split(',')
    result = []
    index = 0
    strarr.each do |element|
      if element && element != ''
        result[index] = element
        index = index + 1
      end
    end
    
    return result
  end
  
  #自动设置公司排名
  def self.autoset_firm_order
    DecoFirm.update_all("orderindex = '' ")
    CITIES.each do |k,v|
      if k == 11910
        cond = "city = 11910 and total_score_new > 0"
      else
        cond = "district = #{k} and total_score_new > 0"
      end
      firms = DecoFirm.find(:all,:select => "id,total_score_new",:order =>"total_score_new desc",:conditions => cond)
      index = 1
      firms.each do |f|
        company = DecoFirm.find(f.id)
        company.update_attribute("orderindex",index)
        index = index + 1
      end
    end
  end
  
  #获得相关日记(同一系)
  def self.get_other_blog(id)
    key = "zhaozhuangxiu_houtai_riji_xilie_#{id}_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = DecoReview.find(:all,:select => "id",:conditions => "id = #{id} or c25 = #{id}",:order => "cdate asc,id asc" )
      resultstr = ''
      index = 1
      result.each do |r|
        resultstr = resultstr + "<a href='/review/show/#{r.id}' target='_blank'>#{index}</a> &nbsp;"
        index = index + 1
      end
      CACHE.set(key,resultstr)
    else
      resultstr = CACHE.get(key)
    end
    return resultstr
  end
  
  #批量修改评论区域
  def self.update_review_city
    reviews = find(:all,:conditions => "formid = '#{PINGLUN_ID}'")
    reviews.each do |r|
      c = get_firm_city(r.company_id)
      r.city_id = c.city
      r.district_id = c.district
      r.save
    end
    
  end
  
  #获得公司区域属性
  def self.get_firm_city(id)
    key = "firm_city_info_#{id}"
    DecoFirm
    if CACHE.get(key).nil?
      result = DecoFirm.find(id,:select => 'id,city,district')
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  #获得所有点评
  def self.get_all_dianping
    result = DecoReview.find(:all,:select => "id,c10,c31",:conditions => "formid = '#{PINGLUN_ID}' and status = '1' ")
    return result
  end
  #更新PV
  def self.update_dianping_c32_pv(id,pv)
    DecoReview.update(id,{:c32=>pv})
  end
  #更新鲜花和鸡蛋
  def self.update_dianping_c10_c31_pv(id,c10,c31)
    DecoReview.update(id,{:c10=>c10,:c31=>c31})
  end
  #计算公司中评论统计量
  def self.cal_commonts_by_companyid(companyid)
    commonts = DecoReview.find(:all,:select => "id,c32,cdate,c2,c18",:conditions => "formid = '#{PINGLUN_ID}' and status = '1' and c1 = '#{companyid}'")
    company_score = 0
    commonts.each do |c|
      company_score = company_score + cal_one_commont(c).to_f
    end
    cscore = JfCompanyScore.find(:first,:conditions => "company_id = '#{companyid}'")
    cscore = JfCompanyScore.new if !cscore || !cscore.id
    cscore.company_id = companyid
    cscore.result_score = company_score
    cscore.cal_date = Time.now
    cscore.save
  end
  
  #计算公司中评论统计量-20091112版
  def self.cal_commonts_by_companyid2(companyid,company)
    company_result = company
    
    design_score = 0.0
    budget_score = 0.0
    construction_score = 0.0
    service_score = 0.0
    #特殊处理新点评
    commonts = DecoReview.find(:all,:select => "id,c32,cdate,c2,c18,c3,c4,c5,c6",:conditions => "formid = '#{PINGLUN_ID}' and status = '1' and c1 = '#{companyid}' and (cdate < '2009-12-30' or exists (select 1 from user_notes where user_notes.dianping_id = radmin_fdatas.id))")
    company_score = 0
    commonts.each do |c|
      temp = cal_one_commont(c).to_f
      #      company_score = company_score + temp
      
      design_score = design_score + temp*c.design_score.to_f
      budget_score = budget_score + temp*c.budget_score.to_f
      construction_score = construction_score + temp*c.construction_score.to_f
      service_score = service_score + temp*c.service_score.to_f
    end
    company_score = design_score + budget_score + construction_score + service_score
    cscore = JfCompanyScore.find(:first,:conditions => "company_id = '#{companyid}'")
    cscore = JfCompanyScore.new if !cscore || !cscore.id
    cscore.company_id = companyid
    cscore.result_score = company_score
    cscore.cal_date = Time.now
    cscore.save
    
  #  company_result.design_score_new = (10 * design_score).round*0.1 
  #  company_result.budget_score_new = (10 * budget_score).round*0.1  
  #  company_result.construction_score_new = (10 * construction_score).round*0.1  
  #  company_result.service_score_new = (10 * service_score).round*0.1  
  #  company_result.total_score_new = (10 * company_score).round*0.1 
  #  company_result.save
    update_adjusted_score(companyid,design_score,budget_score,construction_score,service_score)
   # return company_result
   return false
  end
  
  #计算单个点评
  def self.cal_one_commont(commont)
    JfBase
    #获得计分信息
    score = JfCommontResultScore.find(:first,:conditions => "commont_id = '#{commont.id}'")
    #没有则新建
    score = JfCommontResultScore.new if !score || !score.id 
    score.commont_id = commont.id if !score || !score.id
    score.content_score = cal_commont_content_score(commont,score)
    score.real_score = cal_commont_real_score(score)
    score.important_score = cal_commont_important_score(score)
    score.result_score = cal_commont_result_score(score)
    score.cal_date = Time.now
    score.save
    
    return score.result_score
  end
  
  #计算点评内容分
  def self.cal_commont_content_score(commont,score)
    #编辑评分
    editor_score = get_score_in_range(score.editor_score,get_editor_score_item)
    #点击分
    click_base = get_click_score_item
    if click_base && click_base.id
      click_score = commont.dpv.to_i * click_base.value
    else
      click_score = 0
    end
    #回贴分
    reply_num = DecoReply.count("id",:conditions => "formid = '88' and c1 = '#{commont.id}'")
    reply_base = get_reply_score_item
    reply_score = reply_num.to_i * get_reply_score_item.value
    
    result = editor_score + click_score + reply_score
    
    return result
  end
  
  #计算点评真实分,默认真实返回1
  def self.cal_commont_real_score(score)
    if score.real_score
      return get_score_in_range(score.real_score,get_real_score_item)
    else
      return 1
    end
  end
  
  #计算点评重要度
  def self.cal_commont_important_score(score)
    return get_score_in_range(score.important_score,get_important_score_item)
  end
  
  
  #计算点评综合分
  def self.cal_commont_result_score(score)
    result =  (score.content_score + score.important_score)*score.real_score 
    return result;
  end
  
  #获得范围内的分数
  def self.get_score_in_range(score,baserange)
    if score.nil?
      result = baserange.start_num
    else
      result = score
      result = baserange.start_num if score < baserange.start_num
      result = baserange.end_num if score > baserange.end_num
    end
    return result
  end
  
  #新近分
  def self.get_date_score(date)
    return 0 if !date
    
    #时间差
    days = DateTime.parse(Time.now.strftime('%Y-%m-%d')) - DateTime.parse(date.strftime('%Y-%m-%d'))
    if days >= 0
      items = get_new_commer_item
      result = 0
      items.each do |i|
        result = i.value if i.start_num <= days && days < i.end_num
      end
      
      return result
    else
      return 0
    end
  end
  
  def self.get_simple_company_info(companyid)
    key = "zhaozhuangxiu_back_commont_list_20091117_#{companyid}_#{Time.now.strftime('%Y%m%d')}"
    if CACHE.get(key).nil?
      begin
      result = DecoFirm.find(companyid,:select => 'id,name_zh,is_cooperation')
      rescue
      result = nil
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
  #获得公司星级
  def self.get_star_score(firm,total_score_new)
    return 0 if total_score_new.to_f <= 0
    
    scoreclass = get_star_score_items
    
    scoreclass.each do |score|
      minscore = score.start_num
      maxscore = score.end_num
      paiming = score.value
      result = score.value2
      result2 = score.value3
      #上海加速度
      if firm.city == 11910 
#        minscore = week_speed + minscore
        maxscore = week_speed + maxscore
      end

      #分数范围内
      if total_score_new.to_f >= minscore && total_score_new.to_f<maxscore 

        #排名范围内
        if paiming == -1 || (firm.orderindex.to_i > 0 && firm.orderindex.to_i <= paiming)
          #范围外，降低一级
        elsif (firm.orderindex.to_i > paiming && (result >=4))
          result = result - 0.5
        end
        #结合内定分
        if firm.star_lest.to_f > 0 && firm.star_lest > result
          return firm.star_lest
        else
          return result
        end
        
      end
    
    end
    return 0
  end
  
  
  def self.week_speed
    key = "zhaozhuangxiu_jiasudu_1_#{Time.now.strftime('%Y%m%d')}"
    if CACHE.get(key).nil?
      days = DateTime.parse(Time.now.strftime('%Y-%m-%d')) - DateTime.parse(STARDATE)
      result = (days.to_i/7).to_i
      speed = get_addspeed.value
      result = result * speed
      CACHE.set(key,result)
    
      return result
    else
      return CACHE.get(key).to_i
    end
  end
  
  #获得所有点评
  def self.get_dianping_by_id(id)
    result = DecoReview.find(:all,:conditions => "formid = '#{PINGLUN_ID}' and id=#{id} ")
    return result
  end
end
