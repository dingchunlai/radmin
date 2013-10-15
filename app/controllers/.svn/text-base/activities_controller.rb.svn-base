class ActivitiesController < ApplicationController
	helper :layout
	layout  "activity"
  def index
    @activities = Activity.find(:all)
  end
  
  def show
    @activity = Activity.find(params[:id],:include=>:questions)
  end
  
  def new
    @activity = Activity.new
  end
  
  def create
    @activity = Activity.new(params[:activity])
    if @activity.save
      flash[:notice] = "活动创建成功."
      redirect_to activities_path()
    else
      render :action => 'new'
    end
  end
  
  def edit
    @activity = Activity.find(params[:id])
  end
  
  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "活动更新成功."
      redirect_to  activities_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    flash[:notice] = "Successfully destroyed activity."
    redirect_to activities_url
  end

  # 这其实不是活动的action。
  # 这是专门为一个市场活动而做的报名action。因为功能简单，并且时间紧迫，暂时先放到这个controller里面。
  # 这个action就是简单的把用户信息保存到redis里面。
  def register
    (id    = params[:id] || '').strip!
    (name  = params[:name] || '').strip!
    (phone = params[:phone] || '').strip!

    if id.blank? || name.blank? || phone.blank?
      render :json => '您填写的信息不完整，请重新检查。', :status => 400
    else
      key = "marketing:register:#{id}"
      REDIS_DB.rpush key, Marshal.dump([name, phone])
      render :json => {:id => id, :count => REDIS_DB.llen(key)}.to_json, :status => 200
    end
  rescue
    render :json => "很抱歉，请求处理出现错误，请稍后再尝试。", :status => 500
  end

  # 同上，此action显示活动页面
  def xuangongsi
    @companies = [
      {:id => 17, :name => '原朴装饰', :url => 'http://z.ningbo.51hejia.com/gs-197425/?utm_source=xhjt64&utm_medium=yuanpu', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad18.jpg'},
      {:id => 12, :name => '神话装饰', :url => 'http://z.ningbo.51hejia.com/gs-255826/?utm_source=xhjt64&utm_medium=shenhua', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad13.jpg'},
      {:id => 8,  :name => '南鸿装饰', :url => 'http://z.ningbo.51hejia.com/gs-196338/?utm_source=xhjt64&utm_medium=nanhong', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad09.jpg'},
      {:id => 11, :name => '润泽装饰', :url => 'http://z.ningbo.51hejia.com/gs-256173/?utm_source=xhjt64&utm_medium=runze', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad12.jpg'},
      {:id => 10, :name => '齐元装饰', :url => 'http://z.ningbo.51hejia.com/gs-256292/?utm_source=xhjt64&utm_medium=qiyuan', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad11.jpg'},
      {:id => 6,  :name => '美之家装饰', :url => 'http://z.ningbo.51hejia.com/gs-196225/?utm_source=xhjt64&utm_medium=meizhijia', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad07.jpg'},
      {:id => 7,  :name => '纳德装饰', :url => 'http://z.ningbo.51hejia.com/gs-255828/?utm_source=xhjt64&utm_medium=nade', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad08.jpg'},
      {:id => 14, :name => '文康装饰', :url => 'http://z.ningbo.51hejia.com/gs-256295/?utm_source=xhjt64&utm_medium=wenkang', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad15.jpg'},
      {:id => 16, :name => '易安居装饰', :url => 'http://z.ningbo.51hejia.com/gs-256210/?utm_source=xhjt64&utm_medium=yianju', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad17.jpg'},
      {:id => 0,  :name => '百姓装饰', :url => 'http://z.ningbo.51hejia.com/gs-196322/?utm_source=xhjt64&utm_medium=baixing', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad01.jpg'},
      {:id => 20, :name => '博丽装饰', :url => 'http://z.ningbo.51hejia.com/gs-256112/?utm_source=xhjt64&utm_medium=boli', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad21.jpg'},
      {:id => 5,  :name => '洛雅家装饰', :url => 'http://z.ningbo.51hejia.com/gs-256270/?utm_source=xhjt64&utm_medium=luoyajia', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad06.jpg'},
      {:id => 3,  :name => '鸿盛装饰', :url => 'http://z.ningbo.51hejia.com/gs-255853/?utm_source=xhjt64&utm_medium=hongsheng', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad04.jpg'},
      {:id => 1,  :name => '顶艺装饰', :url => 'http://z.ningbo.51hejia.com/gs-256075/?utm_source=xhjt64&utm_medium=dingyi', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad02.jpg'},
      {:id => 19, :name => '左岸装饰', :url => 'http://z.ningbo.51hejia.com/gs-256367/?utm_source=xhjt64&utm_medium=zuoan', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad20.jpg'},
      {:id => 2,  :name => '鼎峰装饰', :url => 'http://z.ningbo.51hejia.com/gs-256442/?utm_source=xhjt64&utm_medium=dingfeng', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad03.jpg'},
      {:id => 18, :name => '正博装饰', :url => 'http://z.ningbo.51hejia.com/gs-256414/?utm_source=xhjt64&utm_medium=zhengbo', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad19.jpg'},
      {:id => 9,  :name => '欧阳装饰', :url => 'http://z.ningbo.51hejia.com/gs-255824/?utm_source=xhjt64&utm_medium=ouyang', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad10.jpg'},
      #{:id => 15, :name => '阳丽装潢', :url => 'http://z.ningbo.51hejia.com/gs-196279/?utm_source=xhjt64&utm_medium=yangli', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad16.jpg'},
      {:id => 13, :name => '万杰装饰', :url => 'http://z.ningbo.51hejia.com/gs-256330/?utm_source=xhjt64&utm_medium=wanjie', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad14.jpg'},
      {:id => 4,  :name => '聚点装饰', :url => 'http://z.ningbo.51hejia.com/gs-256317/?utm_source=xhjt64&utm_medium=judian', :img => 'http://zt.51hejia.com/zhuanti/nbxzximg/ad05.jpg'}
    ]
    render :layout => false
  end
end
