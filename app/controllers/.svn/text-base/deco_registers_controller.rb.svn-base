class DecoRegistersController < ApplicationController

  # For zhuanti 
  # location http://zt.51hejia.com/zhuanti/jiuding/index.html
  # 是比较传统的方式，没有采用REST风格的
  def form_save
    already_submit = cookies["hejia_deco_register_submit_form_#{request.remote_ip}}"]
    back_url = params[:back_url].blank? ? "http://www.51hejia.com" : params[:back_url]
    if already_submit.nil? || (request.remote_ip == "58.246.26.58")
      register = DecoRegister.new
      register.name = params["name"]
      register.in_city = params["in_city"]
      register.phone = params["phone"]
      register.email = params["email"]
      register.sex = params["sex"]
      register.the_time_to_visit = params["the_time_to_visit"]
      register.remark = params["remark"]
      register.event_id = params["event_id"]
      if register.save
        js_alert = "报名成功 ！"
        cookies["hejia_deco_register_submit_form_#{request.remote_ip}"] = {:value => "register", :expires => 10.minutes.from_now }
        CACHE.delete "deco_registers_event_#{register.id}"
      else
        js_alert = "参数信息错误 ！"
      end
    else
      js_alert = "先休息一下，10分钟再来报名!"
    end
    myrender js_alert, back_url
  end

  # DecoRegister statistics 
  # need params[:event_id]
  # return integer
  def register_count
    register_id, count = params[:event_id].to_i, 0
    if register_id > 0
      key = "deco_registers_event_#{register_id}"
      count = CACHE.fetch(key, 10.minutes) do
        DecoRegister.count("id", :conditions => ["event_id = ?", register_id])
      end
    end
    callback = params[:callback] || 'callback'
    render :text => "#{callback}(#{count.to_json});", :content_type => Mime::JS
  end

end
