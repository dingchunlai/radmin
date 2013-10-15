class PinleiController < ApplicationController
  
  uses_tiny_mce :options => {
      :language => 'zh',
      :theme => 'advanced',
      #:width => "760px",
      :convert_urls => false,
      :relative_urls => false,
      :visual => false,
      :theme_advanced_buttons1 => "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,formatselect,fontselect,fontsizeselect,|,outdent,indent,blockquote,|,undo,redo",
      :theme_advanced_buttons2 => "tablecontrols,|,hr,removeformat,visualaid,code |,hr,removeformat,visualaid,|,link,unlink,anchor,image,upload,cleanup,|,forecolor,backcolor,code",
      :theme_advanced_buttons3 => "",
      :theme_advanced_resizing => false,
      :theme_advanced_resize_horizontal => false,
      :theme_advanced_toolbar_location => "top",
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_statusbar_location => "bottom",
      :plugins => %w{ table fullscreen upload}
    }#,:only => [:new, :create, :edit, :update]

  def list
    return false unless pvalidate("浏览品类列表数据","管理员","文章编辑")
    @sort_id = params[:sort].to_i
    conditions = []
    conditions << "sort_id = #{@sort_id}" if @sort_id != 0
    @pinleis = paging_record options = {
        "model" => Pinlei,
        "pagesize" => 16,   #每页记录数
        "listsize" => 10,  #同时显示的页码数
        "select" => "*",
        "conditions" => conditions.join(" and "),
        "order" => "id desc"
      }
  end

  def edit
    return false unless pvalidate("新建/编辑品类数据","管理员","文章编辑")
    @id = params[:id].to_i
    if @id == 0
      #http://www.51hejia.com/zhannei01/images/pic01.jpg
      #http://www.51hejia.com/zhannei01/images/banner01.jpg
      @pinlei = Pinlei.new
      @pinlei.title_color = ""
      @pinlei.intro_color = ""
      @pinlei.property = <<HERE
      <ul>
        <li class="color01"><span>产地：</span>国产</li>
        <li><span class="color02">性能：</span>材质坚硬、细匀。纹理直，结构粗。耐腐、耐磨，较稳定，易干燥。</li>
        <li class="color01"><span>颜色：</span>白</li>
        <li class="color02"><span>价位：</span>186元/平方米</li>
        <li class="color01"><span>辨别方法：</span>如在和家网站内未找到您需要的商品，亦可直接将产品相关信息(品牌，型号)告知我们客服工作人员我们会在1个工作日内，短信或邮件方式告知该产品的最低价格、购买地址、有效日期；凭此短信或邮件打印件，到商家处即凭此短信或邮件打印件，到商家处即。</li>
        <li><span>铺设及保养：</span>桃花芯木，产地：非洲，质地紧密,有光泽。</li>
        <li class="color01"><span class="color02">专业推荐：</span>材质坚硬、细匀。纹理直，结构粗。耐腐、耐磨，较稳定，易干燥。</li>
      </ul>
HERE
    else
      @pinlei = Pinlei.find(@id)
      @pinlei.title_color = @pinlei.title_color.to_s
      @pinlei.intro_color = @pinlei.intro_color.to_s
    end

  end

  def edit_save
    return false unless pvalidate("保存品类数据","管理员","文章编辑")
    id = params[:id].to_i
    pinlei = params[:pinlei]
    filename = get_file(params[:img_url], "/uploads/pinlei/")
    pinlei["img_url"] = "http://#{request.env["HTTP_HOST"]}/uploads/pinlei/#{filename}" unless filename.nil?
    filename = get_file(params[:bgimg_url], "/uploads/pinlei/")
    pinlei["bgimg_url"] = "http://#{request.env["HTTP_HOST"]}/uploads/pinlei/#{filename}" unless filename.nil?
    if id == 0
      #创建新记录
      pl = Pinlei.create(pinlei)
      rt = alert("操作成功：记录添加成功!") + js(top_load("/pinlei/edit?id=#{pl.id}"))
    else
      #保存修改
      pl = Pinlei.find(id)
      pl.update_attributes(pinlei)
      rt = alert("操作成功：记录已修改!") + js(top_load("self"))
    end
    render :text => rt

  end

  def del
    return false unless pvalidate("删除品类数据","管理员","文章编辑")
    begin
        Pinlei.delete_all "id in (#{params[:ids]})" unless params[:ids].nil?
        render :text => js(top_load("self"))
    rescue Exception => e
        render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

end
