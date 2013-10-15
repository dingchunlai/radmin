class StatisticsController < ApplicationController

  def all
    @riqi1 = params[:riqi1].blank? ? (Date.today - 7) : params[:riqi1]
    @riqi2 = params[:riqi2].blank? ? Date.today : params[:riqi2]
  end

  def operate
    @riqi = params[:riqi].blank? ? (Date.today - 7) : params[:riqi]
    @code = params[:code]
  end
  
  def yusuan
    @riqi1 = params[:riqi1].blank? ? (Date.today - 7) : params[:riqi1]
    @riqi2 = params[:riqi2].blank? ? Date.today : params[:riqi2]
  end

  def delete_all
    @riqi = params[:riqi].blank? ? (Date.today - 7) : params[:riqi]
    if params[:code].blank?
      @statistics = Statistic.find(:all, :conditions => ["created_at < ?",@riqi.to_time.beginning_of_day])
      #Statistic.destroy_all(["created_at < ?", @riqi.to_time.beginning_of_day])
    else
      @statistics = Statistic.find(:all, :conditions => ["code = ? and created_at < ?", params[:code], @riqi.to_time.beginning_of_day])
      #Statistic.destroy_all(["code = ? and created_at < ?", params[:code], @riqi.to_time.beginning_of_day])
    end
    for statistic in @statistics
      statistic.destroy
    end
    redirect_to :action => "operate", :code => params[:code]
  end


  def record_visit_test(host, key)
    REDIS_DB[key.to_s]
  end

  def total
    list = Array.new
    list = DecoReview.get_all_dianping
    i=0
    list.each do |pv|
      DecoReview.update_dianping_c32_pv(pv.id, REDIS_DB["test_zhaozhuangxiu_key_d_#{pv.id}"])
    end
    render :nothing => true
  end

  def company
    list = Array.new
    list = DecoFirm.get_all_decofirms
    list.each do |pv|
      pv.update_attribute(:pv_count, REDIS_DB["test_analytic_zhaozhuangxiu_company_about_key_d_#{pv.id}"])
    end
    render :nothing => true
  end
  
  def reply
    list = DecoReview.get_all_dianping
    list.each do |r|
      i = DecoReply.count :conditions =>"formid=88 and c1=#{r.id} and c3=1"
      r.update_attribute(:response_num,i)
    end
    render :nothing => true
  end

  #日记PV
  def notetotal
    update_sql = "UPDATE #{DecorationDiary.table_name} SET pv = %d WHERE id = %d"
    DecorationDiary.find(:all, :select => 'id', :conditions => "status = 1").each do |r|
      # 不要更新updated_at，所以不能用update方法
      DecorationDiary.connection.execute(update_sql % [
          REDIS_DB["decoration_diaries/#{r.id}/pv"].to_i,
          r.id
        ])
    end
    render :nothing => true
  end

  def index
  end

  def add
    startnum = params[:startnum]
    endnum = params[:endnum]
    list = Array.new
    ids = params[:ids]
    list = ids.split(",")
    list.each do |pv|
      key = "test_analytic_zhaozhuangxiu_company_about_key_d_#{pv}"
      pvcount = REDIS_DB[key]
      count = endnum.to_i - startnum.to_i
      addt  = rand(count)
      addcount   = startnum.to_i + addt
      totalcount = pvcount.to_i + addcount
      REDIS_DB[key] = totalcount
    end
    render :text => alert("操作成功!") + js(top_load("/statistics/index"))
  end

  def addcity
    startnum = params[:startnum]
    endnum = params[:endnum]
    city = params[:city]
    list = Array.new
    list = DecoFirm.get_deco_firms_by_city(city)
    list.each do |pv|
      key = "test_analytic_zhaozhuangxiu_company_about_key_d_#{pv.id}"
      pvcount = REDIS_DB[key]
      count   = endnum.to_i - startnum.to_i
      addt    = rand(count)
      addcount   = startnum.to_i + addt
      totalcount = pvcount.to_i + addcount
      REDIS_DB[key] = totalcount
      pv.update_attribute(:pv_count, totalcount)
    end
    render :text => alert("操作成功!") + js(top_load("/statistics/index"))
  end
  
  def dianping_youyong
    list = Array.new
    list = DecoReview.get_all_dianping
    list.each do |pv|
      key = "user_note/#{pv.id}/pv"
      pvcount = REDIS_DB[key].to_i
      c10 = pv.c10.to_i + 8 + rand(3)
      c31 = pv.c31.to_i + 2 + rand(2)
      DecoReview.update_dianping_c10_c31_pv(pv.id, c10, c31) if pvcount >= (c10 + c31)
    end
    rt = alert("操作成功!")
    render :text => rt + js(top_load("/statistics/index"))
  end
end
