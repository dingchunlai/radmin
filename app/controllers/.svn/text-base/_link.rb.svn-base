  def location
    location = ""
    location << "<a href='/admin/index'>首页</a>&nbsp;>"
    if controller.controller_name == "casemanager"
      location << "<a href='/casemanager/list'>色卡</a>"
      if controller.action_name == "list"
        location << "&nbsp;>列表"
      elsif controller.action_name == "colorcreate"
        location << "&nbsp;>添加色卡"
      elsif controller.action_name == "casecolor"
        location << "&nbsp;>选择色卡数"
      elsif controller.action_name == "colorlist"
        location << "&nbsp;>打色卡"
      elsif controller.action_name == "looks"
        location << "&nbsp;>色卡预览"
      end
    elsif controller.controller_name == "admin"
      location<< "<a href='/decocompany/index'>装潢公司</a>"
      if controller.action_name == "photos"
        location<< "&nbsp;>施工图片"
      end
    elsif controller.controller_name == "wenba"
      location<< "<a href='/wenba/topic_list'>问吧</a>"
      if controller.action_name == "topic_list"
        location << "&nbsp;>问题列表"
      elsif controller.action_name == "focus_topic"
        location << "&nbsp;>焦点问题"
      elsif controller.action_name == "notice_list"
        location << "&nbsp;>公告栏"
      elsif controller.action_name == "wenba_word_filter"
        location << "&nbsp;>关键词过滤"
      elsif controller.action_name == "tag_manage"
        location << "&nbsp;>分类管理"
      end 
    elsif controller.controller_name == "bbs"
      location<< "<a href='/bbs/bbs_word_filter'>论坛</a>"
      if controller.action_name == "bbs_word_filter"
        location << "&nbsp;>关键词过滤"
      elsif controller.action_name == "topic_stat_list"
        location << "&nbsp;>每日统计"
      elsif controller.action_name == "admin_operation"
        location << "&nbsp;>管理员日志"
      end
    elsif controller.controller_name == "ad"
      location<< "<a href='/ad/ad_list'>广告</a>"
      if controller.action_name == "ad_list"
        location << "&nbsp;>所有广告"
      elsif controller.action_name == "new"
        location << "&nbsp;>添加广告"
      end 
    elsif controller.controller_name == "form"
      location<< "<a href='/form/list?status=1'>表单</a>"
      if controller.action_name == "list"
        if params[:status].nil?
          location << "&nbsp;>表单列表"
        elsif !params[:status].nil?&&params[:status].to_s=="1"
          location << "&nbsp;>正常表单"
        elsif !params[:status].nil?&&params[:status].to_s=="0"
          location << "&nbsp;>隐藏表单"
        end
      elsif controller.action_name == "new"
        location << "&nbsp;>创建表单"
      elsif controller.action_name == "data_all"
        location << "&nbsp;>汇总数据" 
      elsif controller.action_name == "decohuodong" 
        location << "&nbsp;>活动数据"        
      end 
    elsif controller.controller_name == "hejia"
      location<< "<a href='/hejia/list'>商城</a>"
      if controller.action_name == "list"
        location << "&nbsp;>核价单管理"
      end
    elsif controller.controller_name == "dingdan"
      location<< "<a href='/hejia/list'>商城</a>"
      if controller.action_name == "vendor_list"
        location << "&nbsp;>商城管理"
      elsif controller.action_name == "list"
        location << "&nbsp;>订单管理"
      end
    elsif controller.controller_name == "vendors"
    
    elsif controller.controller_name == "comment"
      location<< "<a href='/comment/comment_list'>评论</a>"
      if controller.action_name == "comment_list"
        location << "&nbsp;>评论列表"
      end
    elsif controller.controller_name == "hejiatag"
      location<< "<a href='/hejiatag/inner_link_list'>关键字</a>"
      if controller.action_name == "inner_link_list"
        location << "&nbsp;>内联关键字"
      elsif controller.action_name == "hejiatag_list2"
        location << "&nbsp;>新词根目录"
      elsif controller.action_name == "hejiatag_list"
        location << "&nbsp;>旧词根目录"
      elsif controller.action_name == "get_initial"
        location << "&nbsp;>完善首字母"
#      elsif controller.action_name == "hejiatag_list2"
#        location << "&nbsp;>专区管理"
      end
    elsif controller.controller_name == "user"
      location<< "<a href='/user/list'>用户</a>"
      if controller.action_name == "list"
        if params[:role].nil?
          if !params[:state].nil?&&!params[:state].to_s!=""&&!params[:state].to_s=='1'
            location << "&nbsp;>禁用用户"
          else
            location << "&nbsp;>所有用户"
          end
        elsif params[:role].to_s=='115'
          location << "&nbsp;>管理员"
        elsif params[:role].to_s=='126'
          location << "&nbsp;>核价组长"
        elsif params[:role].to_s=='132'
          location << "&nbsp;>问吧管理"
        elsif params[:role].to_s=='121'
          location << "&nbsp;>后台维护"
        elsif params[:role].to_s=='116'
          location << "&nbsp;>论坛编辑"
        elsif params[:role].to_s=='138'
          location << "&nbsp;>兼职文章编辑"
        elsif params[:role].to_s=='133'
          location << "&nbsp;>页面制作" 
        elsif params[:role].to_s=='122'
          location << "&nbsp;>广告管理"
        elsif params[:role].to_s=='139'
          location << "&nbsp;>实习编辑"
        elsif params[:role].to_s=='117'
          location << "&nbsp;>博客编辑"
        elsif params[:role].to_s=='128'
          location << "&nbsp;>产品管理"
        elsif params[:role].to_s=='134'
          location << "&nbsp;>文章编辑"
        elsif params[:role].to_s=='123'
          location << "&nbsp;>会员管理"
        elsif params[:role].to_s=='118'
          location << "&nbsp;>问吧编辑"
        elsif params[:role].to_s=='129'
          location << "&nbsp;>产品组长"
        elsif params[:role].to_s=='124'
          location << "&nbsp;>表单管理"
        elsif params[:role].to_s=='119'
          location << "&nbsp;>关键字管理"
        elsif params[:role].to_s=='130'
          location << "&nbsp;>产品组员"
        elsif params[:role].to_s=='125'
          location << "&nbsp;>核价组员"
        elsif params[:role].to_s=='131'
          location << "&nbsp;>论坛管理"
        elsif params[:role].to_s=='127'
          location << "&nbsp;>订单管理"
        end
      elsif controller.action_name == "new"
        location << "&nbsp;>创建用户"
      end
    elsif controller.controller_name == "webpm"
      location<< "<a href='/webpm/list'>参数</a>"
      if controller.action_name == "list"
        if !params[:sort].nil?&&params[:sort].to_s!=''&&params[:sort].to_s=='1'
          location << "&nbsp;>其他参数"
        else
          location << "&nbsp;>基本参数"
        end
      elsif controller.action_name == "new"
        location << "&nbsp;>添加参数"
      end
    elsif controller.controller_name == "article"
      location<< "<a href='/article/index'>文章</a>"
      if controller.action_name == "index"
        location << "&nbsp;>文章列表"
      elsif controller.action_name == "getfromurl"
        location << "&nbsp;>URL找回文章"
      elsif controller.action_name == "article_collect"
        location << "&nbsp;>文章采集"
      elsif controller.action_name == "changetype"
        location << "&nbsp;>分类迁移"
      elsif controller.action_name == "deletelist"
        location << "&nbsp;>文章回收站"
      elsif controller.action_name == "siteindex"
        location << "&nbsp;>其他资源"
      elsif controller.action_name == "new"
        location << "&nbsp;>添加文章"
      end
    elsif controller.controller_name == "pages"
      location<< "<a href='/pages/index'>页面管理</a>"
      if controller.action_name == "index"
        if params[:show].nil?
          location << "&nbsp;>页面管理列表"
        elsif !params[:show].nil?&&params[:show].to_s=="1"
          location << "&nbsp;>已发布"
        elsif !params[:show].nil?&&params[:show].to_s=="0"
          location << "&nbsp;>未发布"
        end
      elsif controller.action_name == "new"
        location << "&nbsp;>添加页面"
      end
    elsif controller.controller_name == "mobanmanager"
      location<< "<a href='/mobanmanager/index'>模板管理</a>"
      if controller.action_name == "index"
        location << "&nbsp;>模板列表"
      elsif controller.action_name == "new"
        location << "&nbsp;>添加模板"
      end
    elsif controller.controller_name == "articletag"
      location<< "<a href='/articletag/index'>文章标签</a>"
      if controller.action_name == "index"
        location << "&nbsp;>标签列表"
      elsif controller.action_name == "show"
        location << "&nbsp;>修改标签"
      elsif controller.action_name == "create"
        location << "&nbsp;>添加标签"
      end
    elsif controller.controller_name == "decocompany"
      location<< "<a href='/decocompany/index'>装潢公司</a>"
      if controller.action_name == "new"
        location << "&nbsp;>添加新公司"
      elsif controller.action_name == "index"
        location << "&nbsp;>公司列表"
      end
    elsif controller.controller_name == "review"
      location<< "<a href='/review/index'>评论管理</a>"
      if controller.action_name == "index"
        location << "&nbsp;>评论管理列表"
      end
    elsif controller.controller_name == "pinlei"
      location<< "<a href='/pinlei/list'>品类</a>"
      if controller.action_name == "list"
        if params[:sort].nil?
          location << "&nbsp;>所有类型"
        elsif !params[:sort].nil?&&params[:sort].to_s=="1"
          location << "&nbsp;>涂料"
        elsif !params[:sort].nil?&&params[:sort].to_s=="2"
          location << "&nbsp;>地板"
        elsif !params[:sort].nil?&&params[:sort].to_s=="3"
          location << "&nbsp;>瓷砖"
        elsif !params[:sort].nil?&&params[:sort].to_s=="4"
          location << "&nbsp;>卫浴"
        elsif !params[:sort].nil?&&params[:sort].to_s=="5"
          location << "&nbsp;>家具"
        elsif !params[:sort].nil?&&params[:sort].to_s=="6"
          location << "&nbsp;>布艺"
        elsif !params[:sort].nil?&&params[:sort].to_s=="7"
          location << "&nbsp;>家电"
        elsif !params[:sort].nil?&&params[:sort].to_s=="8"
          location << "&nbsp;>橱柜"
        elsif !params[:sort].nil?&&params[:sort].to_s=="9"
          location << "&nbsp;>采暖"
        elsif !params[:sort].nil?&&params[:sort].to_s=="10"
          location << "&nbsp;>照明"
        elsif !params[:sort].nil?&&params[:sort].to_s=="11"
          location << "&nbsp;>水处理"
        end
      elsif controller.action_name == "edit"
        if params[:id].nil?
          location << "&nbsp;>创建新记录"
        else
          location << "&nbsp;>编辑记录"
        end
      end
    elsif controller.controller_name == "zhuanqu"
      location<< "<a href='/zhuanqu/kw_list'>专区</a>"
      if controller.action_name == "kw_list"
        location << "&nbsp;>关键词列表"
      elsif controller.action_name == "kw_edit"
        location << "&nbsp;>创建关键词"
      elsif controller.action_name == "sort_list"
        location << "&nbsp;>分类管理"
      elsif controller.action_name == "memcache"
        location << "&nbsp;>缓存管理"
      end
    elsif controller.controller_name == "hejia_member"
      location<< "<a href='/hejia_member/list'>会员</a>"
      if controller.action_name == "list"
        location << "&nbsp;>最新会员"
      end
    elsif controller.controller_name == "wordmanager"
      location<< "<a href='/wordmanager/list'>关键词管理</a>"
      if controller.action_name == "list"
        location<< "&nbsp;>关键词"
      elsif controller.action_name == "new"
        location << "&nbsp;>添加关键词"
      elsif controller.action_name == "same"
        location << "&nbsp;>添加同义词"
      elsif controller.action_name == "专区"
        location << "&nbsp;>添加专区"
      elsif controller.action_name == "articlekey"
        location << "&nbsp;>文章关键词管理"
      elsif controller.action_name == "keyword"
        location << "&nbsp;>文章自动提取关键词"
      elsif controller.action_name == "artkey"
        location << "&nbsp;>手动关键词"
      end
    end
  end