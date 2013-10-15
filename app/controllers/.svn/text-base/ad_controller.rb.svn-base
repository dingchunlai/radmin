class AdController < ApplicationController

  def ad_list
    return false unless pvalidate("浏览广告列表","管理员","广告管理")
    conditions = []
    conditions << "endtime >= '#{3.days.ago.to_s(:db)}'"
    #conditions << "title = '#{params[:kw]}'" unless params[:kw].nil?
    @ads = paging_record options = {
      "model" => Ad,
      "pagesize" => 99,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "*",
      "conditions" => conditions.join(" and "),
      "order" => "position desc"
    }
  end

  def js_init
    AD_SPACES.each do |e|
      str = <<_CODE_
  function get_hour_id(hour){
    if (hour>=9&&hour<12)
      hour_id = 1;
    else if (hour>=12&&hour<15)
      hour_id = 2;
    else if (hour>=15&&hour<18)
      hour_id = 3;
    else
      hour_id = 4;
    return hour_id;
  }
  function get_suffix(){
    var now = new Date();
    var str = now.getFullYear().toString() + now.getMonth().toString() + now.getDate().toString();
    return str + "_" + get_hour_id(now.getHours());
  }
  var js_src = "http://js.51hejia.com/adc/#{e}_data.js?" + get_suffix();
  document.write("<script type='text/javascript' src='" + js_src + "'></script>");
_CODE_
      filepath = "#{RAILS_ROOT}/public/uploads/adc/#{e}.js"
      file = File.new(filepath, "w")
      file.print(str)
      file.close_write
    end
    render :text => "js_init"
  end

  def new
    @starttime = Time.now.strftime("%Y-%m-%d")
    @endtime = 7.days.from_now.strftime("%Y-%m-%d")
    @pageid = 0
  end

  def new_save
    return false unless pvalidate("保存添加新广告","管理员","广告管理")
    begin
      ad = Ad.new
      ad.customer = strip(params[:customer].to_s)
      ad.position = strip(params[:position].to_s)
      ad.pageid = strip(params[:pageid].to_s)
      ad.starttime = strip(params[:starttime].to_s)
      ad.endtime = strip(params[:endtime].to_s)
      ad.click_code = strip(params[:click_code].to_s)
      ad.view_code = params[:view_code].to_i if params[:view_code].to_i > 0
      ad.scale = strip(params[:scale].to_s)
      ad.created_at = Time.now
      ad.updated_at = Time.now
      ad.save
      Ad.create_all_js
      render :text => alert("操作成功：广告已创建! 您可以继续在本界面添加广告。")
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def edit
    return false unless pvalidate("浏览广告列表","管理员","广告管理")
    ad = Ad.find :first, :conditions=>["id=#{params[:id]}"]
    @id1 = ad.id
    @customer = ad.customer
    @position = ad.position
    @pageid = ad.pageid
    @scale = ad.scale
    @starttime = ad.starttime.strftime("%Y-%m-%d")
    @endtime = ad.endtime.strftime("%Y-%m-%d")
    @click_code = ad.click_code
    @view_code = ad.view_code
  end

  def edit_save
    return false unless pvalidate("保存编辑广告信息","管理员","广告管理")
    begin
      ad = Ad.find(params[:id1].to_i)
      ad.customer = strip(params[:customer].to_s)
      ad.position = strip(params[:position].to_s)
      ad.pageid = strip(params[:pageid].to_s)
      ad.starttime = strip(params[:starttime].to_s)
      ad.endtime = strip(params[:endtime].to_s)
      ad.click_code = strip(params[:click_code].to_s)
      if params[:view_code].to_i > 0
        ad.view_code = params[:view_code].to_i
      else
        ad.view_code = nil
      end
      ad.scale = strip(params[:scale].to_s)
      ad.updated_at = Time.now
      ad.save
      Ad.create_all_js
      render :text => alert("操作成功：广告信息已保存！")
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def ttt(v)

    return v[:order]
  end

  def del
    return false unless pvalidate("删除广告记录","管理员","广告管理")
    begin
      Ad.delete(params[:id]) unless params[:id].nil?
      Ad.delete_all "id in (#{params[:ids]})" unless params[:ids].nil?
      Ad.create_all_js
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

end
