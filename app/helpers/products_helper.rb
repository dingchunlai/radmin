module ProductsHelper
  def page_title
    if controller.controller_name == "home" && controller.action_name == "index"
      "后台首页"
    elsif controller.controller_name == "categories" && controller.action_name == "index"
      "分类列表"
    elsif controller.controller_name == "categories" && controller.action_name == "show"
      @category.name_zh
    elsif controller.controller_name == "categories" && controller.action_name == "new"
      "新建分类"
    elsif controller.controller_name == "categories" && controller.action_name == "edit"
      "编辑分类"
    elsif controller.controller_name == "products" && controller.action_name == "index"
      if (params[:brand] && @brand) && (params[:category] && @category)
        "#{@category.name_zh}分类/#{@brand.name_zh}品牌"
      elsif params[:category] && @category
        "#{@category.name_zh}分类"
      elsif params[:brand] && @brand
        "#{@brand.name_zh}品牌"
      else
        "所有产品"
      end
    elsif controller.controller_name == "products" && controller.action_name == "show"
      @product.name
    elsif controller.controller_name == "products" && controller.action_name == "zxj"
      "装修家"
    elsif controller.controller_name == "products" && controller.action_name == "special"
      "特价产品"
    elsif controller.controller_name == "products" && controller.action_name == "new"
      "新建产品"
    elsif controller.controller_name == "products" && controller.action_name == "edit"
      "编辑产品"
    elsif controller.controller_name == "brands" && controller.action_name == "index" && params[:category_id]
      "#{@category.name_zh}品牌管理"
    elsif controller.controller_name == "brands" && controller.action_name == "index"
      "品牌管理"
    elsif controller.controller_name == "brands" && controller.action_name == "show"
      @brand.name_zh
    elsif controller.controller_name == "brands" && controller.action_name == "category"
      "按类别分类"
    elsif controller.controller_name == "brands" && controller.action_name == "new"
      "新建品牌"
    elsif controller.controller_name == "brands" && controller.action_name == "edit"
      "编辑品牌"
    elsif controller.controller_name == "brands" && controller.action_name == "cooperation"
      "合作品牌"
    elsif controller.controller_name == "brands" && controller.action_name == "noncooperation"
      "非合作品牌"
    elsif controller.controller_name == "brands" && controller.action_name == "hidden"
      "隐藏品牌"
    elsif controller.controller_name == "brands" && controller.action_name == "nonhidden"
      "非隐藏品牌"
    elsif controller.controller_name == "brands" && controller.action_name == "recommend"
      "专区品牌"
    elsif controller.controller_name == "brands" && controller.action_name == "setup"
      "设置#{@brand.name_zh}品牌体验指数"
    elsif controller.controller_name == "markets" && controller.action_name == "index"
      "卖场管理"
    elsif controller.controller_name == "markets" && controller.action_name == "show"
      @market.name_zh
    elsif controller.controller_name == "markets" && controller.action_name == "new"
      "新建卖场"
    elsif controller.controller_name == "markets" && controller.action_name == "edit"
      "编辑卖场"
    elsif controller.controller_name == "vendors" && controller.action_name == "index" && params[:category_id]
      "#{@category.name_zh}商家管理"
    elsif controller.controller_name == "vendors" && controller.action_name == "index" && params[:type] == "cooperation"
      "合作商家"
    elsif controller.controller_name == "vendors" && controller.action_name == "index"
      "商家管理"
    elsif controller.controller_name == "vendors" && controller.action_name == "show"
      @vendor.name_zh
    elsif controller.controller_name == "vendors" && controller.action_name == "new"
      "新建商家"
    elsif controller.controller_name == "vendors" && controller.action_name == "edit"
      "编辑商家"
    elsif controller.controller_name == "vendors" && controller.action_name == "setup"
      "设置账户"
    elsif controller.controller_name == "deposits" && controller.action_name == "index"
      "账户充值记录"
    elsif controller.controller_name == "deposits" && controller.action_name == "new"
      "账户充值"
    elsif controller.controller_name == "params" && controller.action_name == "index" && params[:category_id]
      "#{@category.name_zh}选项管理"
    elsif controller.controller_name == "params" && controller.action_name == "index"
      "选项管理"
    elsif controller.controller_name == "params" && controller.action_name == "show"
      @param.key
    elsif controller.controller_name == "params" && controller.action_name == "new"
      "选项属性"
    elsif controller.controller_name == "params" && controller.action_name == "edit"
      "选项fields_for_param属性"
    elsif controller.controller_name == "properties"
      if controller.action_name == "index" && params[:category_id]
        "#{@category.name_zh}属性管理"
      elsif controller.action_name == "index"
        "属性管理"
      elsif controller.action_name == "show"
        @property.name
      elsif controller.action_name == "new"
        "新建属性"
      elsif controller.action_name == "edit"
        "编辑属性"
      end
    elsif controller.controller_name == "series"
      if controller.action_name == "index" && params[:category_id]
        "#{@category.name_zh}属性管理"
      elsif controller.action_name == "index"
        "系列管理"
      elsif controller.action_name == "show"
        @serie.name
      elsif controller.action_name == "new"
        "新建系列"
      elsif controller.action_name == "edit"
        "编辑系列"
      end
    elsif controller.controller_name == "param_items" && controller.action_name == "new"
      "新建选项"
    elsif controller.controller_name == "param_items" && controller.action_name == "edit"
      "编辑选项"
    elsif controller.controller_name == "search" && controller.action_name == "index"
      "搜索结果"
    elsif controller.controller_name == "json" && controller.action_name == "edit"
      @product.name
    elsif controller.controller_name == "common" && controller.action_name == "category"
      "分类品牌"
    elsif controller.controller_name == "comments" && controller.action_name == "index"
      "咨询管理"
    elsif controller.controller_name == "experiences" && controller.action_name == "index" && params[:category_id]
      "#{@category.name_zh}体验指数"
    elsif controller.controller_name == "experiences" && controller.action_name == "index"
      "体验指数"
    elsif controller.controller_name == "experiences" && controller.action_name == "new"
      "新建指数"
    elsif controller.controller_name == "experiences" && controller.action_name == "edit"
      "编辑指数"
    elsif controller.controller_name == "experiences" && controller.action_name == "show"
      @experience.name
    elsif controller.controller_name == "library_brands" && controller.action_name == "index"
      "品牌库管理"
    elsif controller.controller_name == "library_brands" && controller.action_name == "show"
      @brand.name
    elsif controller.controller_name == "events"
      "事件管理"
    elsif controller.controller_name == "quotes"
      if controller.action_name == "index" && params[:product_id]
        "#{@product.name}报价列表"
      elsif controller.action_name == "index" && params[:vendor_id]
        "#{@vendor.name_zh}报价列表"
      elsif controller.action_name == "index"
        "报价管理"
      elsif controller.action_name == "show"
        "#{@vendor.name_zh} 对 #{@product.name} 的报价"
      end
    else
      "管理后台"
    end
  end

	def common_actions
		actions = ""
		if controller.controller_name == "categories" && controller.action_name == "index"
			actions << "#{link_to '新建类别', new_category_path}"
    elsif controller.controller_name == "categories" && controller.action_name == "show"
      actions << "#{link_to '编辑类别', edit_category_path(@category)}"
		elsif controller.controller_name == "products" && controller.action_name == "show"
			actions << "#{link_to '返回商铺', vendor_path(@product.vendor)}" if @product.vendor
      actions << "#{link_to '编辑产品', edit_product_path(:id => @product.productid)}"
			actions << "#{link_to '新建产品', new_product_path}"
      actions << "#{link_to "查看报价", product_quotes_path(:product_id => @product.id)}"
		elsif controller.controller_name == "products" && controller.action_name == "edit"
			actions << "#{link_to '返回商铺', vendor_path(@product.vendor)}" if @product.vendor
			actions << "#{link_to '新建产品', new_product_path}"
		elsif controller.controller_name == "products"
			actions << "#{link_to '新建产品', new_product_path}"
		elsif controller.controller_name == "params"
			actions << "#{link_to '添加可选项', new_param_item_path(:param_id => params[:id])}" if controller.action_name == "show"
      actions << "#{link_to '编辑选项', edit_param_path(@param)}" if controller.action_name == "show"
			actions << "#{link_to '新建选项', new_param_path}"
		elsif controller.controller_name == "properties"
      actions << "#{link_to '编辑属性', edit_property_path(@property)}" if controller.action_name == "show"
			actions << "#{link_to '新建属性', new_property_path}"
		elsif controller.controller_name == "brands" && controller.action_name == "show"
			actions << "#{link_to '添加产品', new_product_path(:brand_id => @brand.id)}"
      actions << "#{link_to '添加系列', new_serie_path(:brand_id => @brand.id)}"
      actions << "#{link_to "设置指数", setup_brand_path(@brand) if @brand.categories.any?}"
			actions << "#{link_to '编辑品牌', edit_brand_path(@brand)}"
			actions << "#{link_to '新建品牌', new_brand_path}"
		elsif controller.controller_name == "brands"
			actions << "#{link_to '全部品牌', brands_path}"
      actions << "#{link_to '专区品牌', recommend_brands_path}"
      actions << "#{link_to '合作品牌', cooperation_brands_path}"
			actions << "#{link_to '非合作品牌', noncooperation_brands_path}"
      actions << "#{link_to '隐藏品牌', hidden_brands_path}"
      actions << "#{link_to '非隐藏品牌', nonhidden_brands_path}"
      actions << "#{link_to '新建品牌', new_brand_path}"
    elsif controller.controller_name == "vendors" && controller.action_name == "show"
			actions << "#{link_to '添加产品', new_product_path(:vendor_id => @vendor.id)}"
			actions << "#{link_to '编辑商铺', edit_vendor_path(@vendor)}"
      actions << "#{link_to "设置账户", setup_vendor_path(@vendor) if has_role?("产品组长")}"
      actions << "#{link_to "账户充值记录", vendors_deposits_path(:vendor_id => @vendor.id) if has_role?("产品组长")}"
      actions << "#{link_to "<strong>账户充值</strong>", new_vendors_deposit_path(:vendor_id => @vendor.id) if has_role?("产品组长")}"
		elsif controller.controller_name == "vendors"
			actions << "#{link_to '新建商铺', new_vendor_path}"
      actions << "#{link_to '合作商铺', vendors_path(:type => "cooperation")}"
		elsif controller.controller_name == "deposits"
			actions << "#{link_to '返回商铺', vendor_path(@vendor)}"
		elsif controller.controller_name == "markets" && controller.action_name == "show"
			actions << "#{link_to '添加商铺', new_vendor_path(:market_id => @market)}"
			actions << "#{link_to '编辑卖场', edit_market_path(@market)}"
			actions << "#{link_to '新建卖场', new_market_path}"
		elsif controller.controller_name == "markets"
			actions << "#{link_to '新建卖场', new_market_path}"
    elsif controller.controller_name == "experiences" && params[:category_id]
			actions << "#{link_to '新建指数', new_experience_path(:id => @category.id)}"
    elsif controller.controller_name == "experiences"
			actions << "#{link_to '新建指数', new_experience_path}"
    elsif controller.controller_name == "search"
      actions << "共有 <strong>#{@result.total_entries }</strong> 项符合你的搜索条件"
    elsif controller.controller_name == "library_brands"
      actions << "#{link_to "品牌库管理", library_brands_path}"
      actions << "#{link_to '新建品牌', new_library_brand_path}"
      actions << "#{link_to '添加文章', "/article/new", :target => "_blank"}"
    elsif controller.controller_name == "events"
      actions << "#{link_to "新建事件", "/events/new"}"
    elsif controller.controller_name == "series"
      actions << "#{link_to "新建系列", "/series/new"}"
    end
		return actions
	end

#  def format_price(price, unit)
#    price_string = ""
#    price_string << "<span>#{(price && price != 0) ? number_to_currency(price, :unit => '', :precision => 0, :delimiter => "") : '电询 '}</span>"
#    price_string << "元/"+"#{unit || '件'}"
#    return price_string
#  end

  def format_currency(currency)
    number_to_currency(currency, :unit => '&yen;')+ "元"
  end

  def format_status(status)
    case status
      when 0 then "核价中"
      when 1 then "待预约"
      when 2 then "已预约"
      when 3 then "已成交"
      when 4 then "已作废"
      else "其他"
    end
  end

  def vendor_link(vendor, link_text)
    link = (vendor.subdomain ? "http://#{vendor.subdomain}.51hejia.com/" : "#{vendor_path(vendor)}")
    return (vendor.subdomain ? "<span class='subdomain'>#{link_to link_text, link, :target => '_blank'}</span>" : "#{link_to link_text, link, :target => '_blank'}")
  end

  def brand_link(brand, link_text)
      link = (brand.vendors.size > 0 ? "http://#{brand.vendors[0].subdomain}.51hejia.com/" : "#{brand_path(brand)}")
      return (brand.vendors.size > 0 ? "<span class='brand-subdomain'>#{link_to link_text, link, :title => brand.name_zh}</span>" : "#{link_to link_text, link, :title => brand.name_zh}")
  end

	def class_index_string(n)
		case n
			when 0 then	"普通"
			when 1 then	"一钻"
			when 2 then	"两钻"
			when 3 then	"三钻"
			when 4 then	"四钻"
			when 5 then	"五钻"
			when 6 then	"皇冠"
			when 7 then	"双皇冠"
			when 8 then	"三皇冠"
			when 9 then	"四皇冠"
			when 10 then"五皇冠"
		end
	end

	def service_index_string(n)
		case n
			when 0 then	"普通"
			when 1 then	"服务等级1"
			when 2 then	"服务等级2"
			when 3 then	"服务等级3"
			when 4 then	"服务等级4"
			when 5 then	"服务等级5"
		end
	end

	def cooperation_string(n)
		case n
			when 0 then	"普通"
			when 1 then	"配合等级1"
			when 2 then	"配合等级2"
			when 3 then	"配合等级3"
			when 4 then	"配合等级4"
			when 5 then	"配合等级5"
		end
	end

	def typehood_string(n)
		case n
			when 0 then	"核价"
			when 1 then	"超低价"
			when 2 then	"陪购"
			when 3 then	"电询"
		end
	end

  def product_status(n)
    case n
      when 0 then "<span class='status0'>待审核</span>"
      when 1 then "<span class='status1'>已上架</span>"
      when 2 then "<span class='status2'>已审核</span>"
      when 3 then "<span class='status3'>待上架</span>"
      when 4 then "<span class='status4'>已下架</span>"
      when 5 then "<span class='status5'>待下架</span>"
    end
  end

  def label_string(n)
    case n
      when "new" then "新品"
      when "distinctive" then "特色"
      when "classical" then "经典"
    end
  end

  def promotion_state(s)
    case s
      when "open" then "未处理"
      when "processed" then "已处理"
    end
  end

  # This helper method is used to generate the javascript to execute on the client
  # It assumes that the function update_select_options is already in the open document
  #
  # Options
  # :text - The method to use on collection objects to get the text for the option
  # :value - The method to use on collection objects to get the value attribute for the option
  # :include_blank - Includes a blank option at the top of cascaded boxes
  # :clear - An array that contains the dom id's of select boxes to clear when target_dom_id changes
  def update_select_box(target_dom_id, collection, options={})
    # Set the default options
    options[:text] ||= 'name'
    options[:value] ||= 'id'
    options[:include_blank] = true if options[:include_blank].nil?
    options[:clear] ||= []
    pre = options[:include_blank] ? [['','']] : []

    out = "update_select_options( $('" << target_dom_id.to_s << "'),"
    out << "#{(pre + collection.collect{ |c| [c.send(options[:text]), c.send(options[:value])]}).to_json}" << ","
    out << "#{options[:clear].to_json} )"
  end

  def fields_for_param(param, &block)
    prefix = param.new_record? ? 'new' : 'existing'
    fields_for("product[#{prefix}_param_attributes][]", param, &block)
  end

  def fields_for_property(property, &block)
    prefix = property.new_record? ? 'new' : 'existing'
    fields_for("product[#{prefix}_property_attributes][]", property, &block)
  end
  def fields_for_experience(experience, &block)
    prefix = experience.new_record? ? 'new' : 'existing'
    fields_for("brand[#{prefix}_experience_attributes][]", experience, &block)
  end

  def fields_for_image(image, &block)
    prefix = image.new_record? ? 'new' : 'existing'
    fields_for("product[#{prefix}_image_attributes][]", image, &block)
  end

	def add_image_link(name)
		link_to_function name do |page|
			page.insert_html :bottom, :images, :partial => 'image_form', :object => ProductImage.new
		end
	end

  def has_role?(name)
    staff_logged_in? and (current_staff.roles.include?(name) or current_staff.admin?)
  end

  def comment_state(s)
    case s
      when "open" then "未回复"
      when "replied" then "已回复"
    end
  end

  def product_button(product)
    if product.vendor_id == 10
      link_to image_tag("/images/buttons/add-to-cart.gif", :alt => "预约购买"), {:controller => "pricings", :action => "new", :id => product.productid}, :method => "post", :class => "btn", :target => "_blank"
    else
      if product.typehood == 1
        link_to image_tag("/images/buttons/add-to-cart.gif", :alt => "预约购买"), {:controller => "cart", :action => "add", :id => product.productid}, :method => "post", :class => "btn", :target => "_blank"
      else
        if controller.controller_name == "products" && controller.action_name == "show"
          link_to image_tag("/images/buttons/pricing_new.gif", :alt => "我要最低报价"), {:controller => "pricings", :action => "new", :id => product.productid}, :class => "btn", :target => "_blank"
        else
          link_to image_tag("/images/buttons/pricing.gif", :alt => "我要最低报价"), {:controller => "pricings", :action => "new", :id => product.productid}, :class => "btn", :target => "_blank"
        end
      end
    end
  end

  def format_tags(tags)
    tags_string = ""
    tags.split(" ").collect{|tag| tags_string << "<a href='/search?query=#{tag}&search_type=1' title='#{tag}' target='_blank'>#{tag}</a>"}
    return tags_string
  end

  def format_price(price, unit, typehood = nil)
    price_string = ""
    if typehood && typehood == 3
      price_string << "<span>特价中</span> 电询"
    else
      price_string << "<span>#{(price && price != 0 && price != 888888) ? number_to_currency(price, :unit => '', :precision => 0, :delimiter => "") : '电询 '}</span>"
      price_string << "元/"+"#{unit || '件'}"
    end
    return price_string
  end
  
  def vendor_link(vendor, link_text)
    link = (vendor.subdomain && vendor.subdomain != "" ? "http://#{vendor.subdomain}.51hejia.com/" : "#{vendor_path(vendor)}")
    return (vendor.subdomain && vendor.subdomain != "" ? "<span class='subdomain'>#{link_to link_text, link, :target => '_blank'}</span>" : "#{link_to link_text, link, :target => '_blank'}")
  end

  def class_index_image(n)
    if n != nil && n != 0
      if n >= 1 && n <= 5
        (1..n).collect{"<img src='/images/icons/diamond.gif' />"}
      else
        (1..n-5).collect{"<img src='/images/icons/crown.gif' />"}
      end
    else
      "普通"
    end
  end
  
end
