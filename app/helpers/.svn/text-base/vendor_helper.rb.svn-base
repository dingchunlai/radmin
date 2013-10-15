module VendorHelper
  def vendor_page_title
    if controller.controller_name == "vendor" && controller.action_name == "index"
      "管理首页"
    elsif controller.controller_name == "vendor" && controller.action_name == "login"
      "商铺登录"
    elsif controller.controller_name == "vendor" && controller.action_name == "profile"
      "账户信息"
    elsif controller.controller_name == "vendor" && controller.action_name == "change_password"
      "修改密码"
    elsif controller.controller_name == "vendor" && controller.action_name == "edit"
      "修改资料"
    elsif controller.controller_name == "products" && controller.action_name == "index"
      "产品列表"
    elsif controller.controller_name == "products" && controller.action_name == "new"
      "新建产品"
    elsif controller.controller_name == "products" && controller.action_name == "show"
      @product.name
    elsif controller.controller_name == "products" && controller.action_name == "edit"
      "编辑产品"
    elsif controller.controller_name == "merchandises" && controller.action_name == "index"
      "产品列表"
    elsif controller.controller_name == "merchandises" && controller.action_name == "new"
      "新建产品"
    elsif controller.controller_name == "merchandises" && controller.action_name == "show"
      @product.name
    elsif controller.controller_name == "merchandises" && controller.action_name == "edit"
      "编辑产品"
    elsif controller.controller_name == "promotions" && controller.action_name == "index"
      "促销列表"
    elsif controller.controller_name == "promotions" && controller.action_name == "show"
      @promotion.title
    elsif controller.controller_name == "promotions" && controller.action_name == "new"
      "新建促销"
    elsif controller.controller_name == "promotions" && controller.action_name == "edit"
      "编辑促销"
    elsif controller.controller_name == "pricings" && controller.action_name == "index"
      "核价单管理"
    elsif controller.controller_name == "pricings" && controller.action_name == "edit"
      "编辑核价单"
    elsif controller.controller_name == "comments" && controller.action_name == "index"
      "咨询管理"
    elsif controller.controller_name == "honors" && controller.action_name == "index"
      "荣誉管理"
    elsif controller.controller_name == "honors" && controller.action_name == "new"
      "新建荣誉"
    elsif controller.controller_name == "honors" && controller.action_name == "edit"
      "编辑荣誉"
    elsif controller.controller_name == "honors" && controller.action_name == "show"
      @honor.title
    elsif controller.controller_name == "cases" && controller.action_name == "index"
      "案例管理"
    elsif controller.controller_name == "cases" && controller.action_name == "new"
      "新建案例"
    elsif controller.controller_name == "cases" && controller.action_name == "edit"
      "编辑案例"
    elsif controller.controller_name == "cases" && controller.action_name == "show"
      @case.title
    elsif controller.controller_name == "banners" && controller.action_name == "index"
      "店铺头部图片管理"
    elsif controller.controller_name == "banners" && controller.action_name == "new"
      "新建店铺头部图"
    elsif controller.controller_name == "banners" && controller.action_name == "edit"
      "编辑店铺头部图"
    elsif controller.controller_name == "banners" && controller.action_name == "show"
      @banner.title
    elsif controller.controller_name == "sales" && controller.action_name == "index"
      "店铺促销广告图管理"
    elsif controller.controller_name == "sales" && controller.action_name == "new"
      "新建店铺促销广告图"
    elsif controller.controller_name == "sales" && controller.action_name == "edit"
      "编辑店铺促销广告图"
    elsif controller.controller_name == "sales" && controller.action_name == "show"
      @sale.title
    elsif controller.controller_name == "vendor_search" && controller.action_name == "index"
      "搜索结果"
    elsif controller.controller_name == "quotes"
      if controller.action_name == "index"
        "报价管理"
      elsif controller.action_name == "show"
        "#{@product.name}报价"
      elsif controller.action_name == "new"
        "新建报价"
      elsif controller.action_name == "edit"
        "编辑报价"
      end
    else
      "自助管理系统"
    end
  end

	def vendor_common_actions
		actions = ""
		if controller.controller_name == "vendor" && controller.action_name == "profile"
      actions << "#{link_to '编辑账户', config_path}"
			actions << "#{link_to '修改密码', '/vendor/change_password'}"
    elsif controller.controller_name == "products" && controller.action_name == "show"
      actions << "#{link_to '编辑产品', edit_vendor_merchandise_path(:id => @product.productid)}"
			actions << "#{link_to '新建产品', new_vendor_merchandise_path}"
		elsif controller.controller_name == "products" && controller.action_name == "edit"
			actions << "#{link_to '返回商铺', '/vendor'}" if @product.vendor
			actions << "#{link_to '新建产品', new_vendor_merchandise_path}"
		elsif controller.controller_name == "products"
			actions << "#{link_to '新建产品', new_vendor_product_path}"
		elsif controller.controller_name == "merchandises"
			actions << "#{link_to '', ''}"
    elsif controller.controller_name == "brands" && controller.action_name == "show"
			actions << "#{link_to '添加产品', new_merchandise_path(:brand_id => @brand.id)}"
			actions << "#{link_to '编辑品牌', edit_brand_path(@brand)}"
			actions << "#{link_to '新建品牌', new_brand_path}"
		elsif controller.controller_name == "brands"
			actions << "#{link_to '新建品牌', new_brand_path}"
		elsif controller.controller_name == "promotions"
			actions << "#{link_to '新建店铺促销广告图', new_vendor_promotion_path}"
		elsif controller.controller_name == "pricings" && controller.action_name == "index"
			actions << "共有#{@pricings.total_entries}笔核价单"
    elsif controller.controller_name == "comments"
			actions << "共有#{@comments.total_entries}条咨询"
    elsif controller.controller_name == "honors"
			actions << "#{link_to '新建荣誉', new_vendor_honor_path}"
    elsif controller.controller_name == "banners"
			actions << "#{link_to '新建店铺头部图', new_vendor_banner_path}"
    elsif controller.controller_name == "cases"
			actions << "#{link_to '新建案例', new_vendor_case_path}"
    elsif controller.controller_name == "sales"
			actions << "#{link_to '新建促销图片', new_vendor_sale_path}"
    elsif controller.controller_name == "quotes"
			actions << "#{link_to '产品管理', vendor_products_path}"
    elsif controller.controller_name == "vendor_search"
      actions << "共有 <strong>#{@result.total_entries}</strong> 项符合你的搜索条件"
		end
		return actions
	end

	def add_promotion_image_link(name)
		link_to_function name do |page|
			page.insert_html :bottom, :images, :partial => 'image_form', :object => ProductVendorPromotionImage.new
		end
	end

  def pricing_state(s)
    case s
      when 0 then "待处理"
      when 1 then "已处理"
      when 2 then "已发送"
      when 3 then "已作废"
      when 4 then "已成交"
      when 5 then "已放弃"
      when 6 then "已分配"
    end
  end

  def comment_state(s)
    case s
      when "open" then "未回复"
      when "replied" then "已回复"
    end
  end

end
