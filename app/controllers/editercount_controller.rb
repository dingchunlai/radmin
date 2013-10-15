class EditercountController < ApplicationController
  #统计某编辑1天审核，发布，退回文章
  def countbyeditor
    @stype = params[:stype]           #文章类型
    @channel = params[:channel]       #选择频道
    @begindate = params[:begindate]   #开始时间
    @enddate = params[:enddate]       #结束时间
    
    #频道列表
    @channellist = ArticleTag.article_categories 
    
    #搜索条件齐全才做查询
    if @stype && @stype != '' && @channel && @channel != '' && @begindate && @begindate && @enddate && @enddate
      #每种文章数量
      @uncheck = Article.countarticledate(@begindate,@enddate,2,@channel,@stype)
      @checked = Article.countarticledate(@begindate,@enddate,3,@channel,@stype)
      @published = Article.countarticledate(@begindate,@enddate,0,@channel,@stype)
      @backed = Article.countarticledate(@begindate,@enddate,-2,@channel,@stype)
      #分数
      @score =  Operatelogscore.getscore(@begindate,@enddate,@channel,@stype)
    else
      @message = 1
    end  
    
  end
  
  #详细编辑情况
  def countdetail
    ps = 20
    @editorid = params[:editorid]     #编辑id
    @stype = params[:stype]           #文章类型
    @onedate = params[:onedate]       #选择时间 
    @channel = params[:channel]       #选择频道
    @begindate = params[:begindate]   #开始时间
    @enddate = params[:enddate]       #结束时间
    @state = params[:state]           #状态
    
    #获得编辑角色
    editorjuese = Webpm.find(:first,:conditions => "value='文章编辑'")
    
    #获得编辑列表
    @users = User.find(:all,:conditions => "role like '%#{editorjuese.id}%'" )
    
    #频道列表
    @channellist = ArticleTag.article_categories 
    
    conditions = []
    conditions << "STATE <> '-1'"
    conditions << "FIRSTCATEGORY = '#{@channel}'" if @channel && @channel != ''
    conditions << "CITYORDERBY = '#{@stype}'" if @stype && @stype != ''
    conditions << "STATE = '#{@sate}'" if @sate && @sate != ''
    conditions << "EDITPEOPLE = '#{@editorid}'" if @editorid && @editorid != ''
    conditions << "STATE = '#{@state}'" if @state && @state != ''
    
    #选择了开始结束时间就用该条件，否则按某一天统计
    if (@begindate && @begindate != '') || (@enddate && @enddate != '')
      conditions << "CREATETIME > '#{@begindate}'" if @begindate && @begindate != ''
      conditions << "CREATETIME < '#{@enddate}'" if @enddate && @enddate != ''   
    elsif @onedate && @onedate != ''
      conditions << "DATE_FORMAT(CREATETIME, '%Y-%m-%d')= '#{@onedate}'" 
      ps = 100
    end
    
    @articles = Article.paginate :page => params[:page], :per_page => ps,
    :conditions => conditions.join(" and "),
    :order => "ID desc"
  end
  
  #编辑查看自己分数
  def lookselfscore
    @username = current_staff.name
    @date = params[:date]
    @begindate = params[:begindate]
    @enddate = params[:enddate]
    
    if (@begindate && @enddate) || @date
      @channeldate = Operatelogscore.getUserChannel(current_staff.id, @date, @begindate, @enddate)
      @result = Operatelogscore.getScoreByUserDate(current_staff.id, @date, @begindate, @enddate)
    end
  end
  
  #频道负责人查看频道分数
  def lookchannelscore
    @date = params[:date]
    @begindate = params[:begindate]
    @enddate = params[:enddate]
    
    if (@begindate && @enddate) || @date
      if myisrole("推广文章负责人")
        @alist = Operatelogscore.getScoreByMaster(@date,'1',@begindate,@enddate)
      end
      if myisrole("新闻负责人")
        @blist = Operatelogscore.getScoreByMaster(@date,'2',@begindate,@enddate)
      end
      if myisrole("实用文章负责人")
        @clist = Operatelogscore.getScoreByMaster(@date,'3',@begindate,@enddate)
      end    
    end
  end
  
  #老总,系统管理员看所有数据(按照编辑查看)
  def seealleditor
    @begindate = params[:begindate]
    @enddate = params[:enddate]
    
    if @begindate && @enddate && @begindate != '' && @enddate != ''
      @result = []
      
      #搜索时间段内有分数的编辑
      userlist = Operatelogscore.getEditorsByDate(@begindate,@enddate)
      
      if userlist
        #根据每个编辑查询
        userlist.each do |u|
          #编辑频道信息
          channeluser = Operatelogscore.getUserChannel(u.userid,nil,@begindate,@enddate)
          #分数信息
          score = Operatelogscore.getScoreByUserDate(u.userid,nil,@begindate,@enddate)
          
          #组合数据
          r = []
          r << channeluser
          r << score
          
          @result << r
        end
      end
    end    
  end
  
  #老总,系统管理员看所有数据(按照频道查看)
  def seeallchannel
    @begindate = params[:begindate]
    @enddate = params[:enddate]
    
    if @begindate && @enddate && @begindate != '' && @enddate != ''
      #获得有分数的频道
      @channellist = Operatelogscore.getChannelsByDate(@begindate,@enddate)
      @result = []
      if @channellist
        #获得每个频道统计数据
        @channellist.each do |onechannel|
          @result << Operatelogscore.getScoreByChannelDate(onechannel.channel,@begindate,@enddate)
        end
      end
    end    
  end
  
  def myisrole(name)
    staff_logged_in? and current_staff.roles.include?(name)
  end
end
