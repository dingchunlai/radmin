class LsbfmController < ApplicationController
  before_filter :user_validate, :except => :login #验证用户身份 
  
  def lsbfm_list
    @pagesize = 10 #每页记录数
    @listsize = 10 #同时显示的页码数

      condition = "true"
      condition += " and category='#{params[:category]}'" if pp(params[:category])
      if params[:page].nil?
        @curpage = 1
      else
        @curpage = params[:page].to_i
      end
      if params[:recordcount].nil?
        @recordcount = Lsbfm.count("id", :conditions => condition)
      else
        @recordcount = params[:recordcount].to_i
      end
      @pagecount = (1.0 * @recordcount / @pagesize).ceil

      @lsbfms = Lsbfm.find :all,
        :select => "id, category, lsbfmc1, lsbfmc3, lsbfmc4, lsbfmc5, cdate, udate",
        :conditions => condition,
        :offset => @pagesize * (@curpage - 1),
        :limit => @pagesize,
        :order => "id desc"
  end
  
  def lsbfm_del #删除记录
    begin
      Lsbfm.delete(params[:id]) if pp(params[:id])
      Lsbfm.delete_all "id in (#{params[:ids]})" if pp(params[:ids])
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error(get_error(e))
    end
  end
  
  def lsbfm_new
  end
  
  def lsbfm_new_save
    begin
          lsbfm = Lsbfm.new
          lsbfm.category = strip(params[:category])
          lsbfm.lsbfmc1 = strip(params[:lsbfmc1])
          lsbfm.lsbfmc2 = strip(params[:lsbfmc2])
          lsbfm.lsbfmc3 = strip(params[:lsbfmc3])
          lsbfm.lsbfmc4 = strip(params[:lsbfmc4])
          lsbfm.lsbfmc5 = strip(params[:lsbfmc5])
          lsbfm.cdate = Time.now
          lsbfm.udate = Time.now
          lsbfm.save
          render :text => alert("记录添加成功!") + js(top_load("/lsbfm/lsbfm_edit?id=#{lsbfm.id}"))
      rescue Exception => e
          render :text => alert_error(get_error(e))
      end
  end
  
  def lsbfm_edit
    begin
      @lsbfm = Lsbfm.find(params[:id])
    rescue Exception => e
          show_notice(get_error(e))
    end
  end
  
  def lsbfm_edit_save
    begin
    lsbfm = Lsbfm.find(params[:id])
    lsbfm.category = strip(params[:category])
    lsbfm.lsbfmc1 = strip(params[:lsbfmc1])
    lsbfm.lsbfmc2 = strip(params[:lsbfmc2])
    lsbfm.lsbfmc3 = strip(params[:lsbfmc3])
    lsbfm.lsbfmc4 = strip(params[:lsbfmc4])
    lsbfm.lsbfmc5 = strip(params[:lsbfmc5])
    lsbfm.udate = Time.now
        lsbfm.save
        render :text => alert("更新操作成功!")
    rescue Exception => e
        render :text => alert_error(get_error(e))
    end
  end
  
  def create_file(spath, tpath, tname)
      begin
          lsbfm = File.new(spath, mode="r")
          printstr = lsbfm.read().to_s
          printstr = printstr.gsub("lsbfmc1", params[:c1])
          printstr = printstr.gsub("lsbfmc2", params[:c2])
          printstr = printstr.gsub("lsbfmc3", params[:c3])
          printstr = printstr.gsub("lsbfmc4", params[:c4])
          printstr = printstr.gsub("lsbfmc5", params[:c5])
          printstr = printstr.gsub("Lsbfm", tname.capitalize).gsub("lsbfm", tname) #取得目标文件内容
          file = File.new(tpath, mode="w")   
          file.print(printstr)
          lsbfm.close_read
          file.close_write
          puts tpath + " -> Generate Success!"
      rescue Exception => e
          puts tpath + " Generate Error: " + e.to_s
      end
  end
  
  def generate  #生成功能模块
    if request.post?
      sname = "lsbfm"
      tname = strip(params[:tname])
      if /^[a-z]+$/ =~ tname
          
        spath = "app/controllers/" + sname + "_controller.rb" 
        tpath = "app/controllers/" + tname + "_controller.rb"
        if File.exist?(tpath)
            render :text => alert_error("生成失败：" + tpath + " 文件已经存在!") 
            return false
        end        
        create_file(spath, tpath, tname) #生成controller文件
        
        spath = "app/views/layouts/" + sname + ".rhtml" 
        tpath = "app/views/layouts/" + tname + ".rhtml" 
        create_file(spath, tpath, tname) #生成layout文件
        
        spath = "app/models/" + sname + ".rb"
        tpath = "app/models/" + tname + ".rb"
        create_file(spath, tpath, tname) #生成model文件
        
        FileUtils.mkdir("app/views/" + tname) if !File.exist?("app/views/" + tname) #创建views下的文件夹
        spath = "app/views/#{sname}/#{sname}_list.rhtml"
        tpath = "app/views/#{tname}/#{tname}_list.rhtml"
        create_file(spath, tpath, tname) #生成list文件
        
        spath = "app/views/#{sname}/#{sname}_new.rhtml"
        tpath = "app/views/#{tname}/#{tname}_new.rhtml"
        create_file(spath, tpath, tname) #生成new文件
        
        spath = "app/views/#{sname}/#{sname}_edit.rhtml"
        tpath = "app/views/#{tname}/#{tname}_edit.rhtml"
        create_file(spath, tpath, tname) #生成edit文件
        
        spath = "app/views/#{sname}/_#{sname}_form.rhtml"
        tpath = "app/views/#{tname}/_#{tname}_form.rhtml"
        create_file(spath, tpath, tname) #生成form文件
        
        dosql("CREATE TABLE `#{tname}s` (
        `id` int(11) NOT NULL auto_increment,
        `category` varchar(127) default NULL,
        `#{params[:c1]}` varchar(127) default NULL,
        `#{params[:c2]}` varchar(127) default NULL,
        `#{params[:c3]}` varchar(127) default NULL,
        `#{params[:c4]}` varchar(127) default NULL,
        `#{params[:c5]}` varchar(127) default NULL,
        `cdate` datetime default NULL,
        `udate` datetime default NULL,
        PRIMARY KEY  (`id`)
        ) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;")     
      
        1.upto(10) do |i|
         dosql("INSERT INTO `#{tname}s` VALUES ('#{i}', 'first', 'column1_1', 'column1_2', 'column1_3', 'column1_4', 'column1_5', '2008-10-23 16:37:58', '2008-10-23 16:37:58');")
        end
        
        11.upto(20) do |i|
         dosql("INSERT INTO `#{tname}s` VALUES ('#{i}', 'second', 'column1_1', 'column1_2', 'column1_3', 'column1_4', 'column1_5', '2008-10-23 16:37:58', '2008-10-23 16:37:58');")
        end
        
        21.upto(30) do |i|
         dosql("INSERT INTO `#{tname}s` VALUES ('#{i}', 'third', 'column1_1', 'column1_2', 'column1_3', 'column1_4', 'column1_5', '2008-10-23 16:37:58', '2008-10-23 16:37:58');")
        end
        
        render :text => alert("模块生成成功!") + js("window.open('/#{tname}/#{tname}_list','_blank');")
      else
        render :text => alert_error("模块名称只能由小写英文字母组成!");
      end
    end
  end
  
  
end
