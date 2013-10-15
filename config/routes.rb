ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  #map.resources :vendors, :path_prefix => 'p', :name_prefix => 'p_', :controller => 'p/vendors'
  #map.connect '/vendor/products/:action/:id', :controller => "vendor/products"

  map.page_files '/files/outfile/:id.html', :controller => 'pages', :action => 'static_files'
  map.resources :applicants 
  map.resources :paint_keywords

  #登录界面



  map.resources :deco_ideas, :controller =>"decos/deco_ideas"
  map.resources :deco_services, :controller =>"decos/deco_services"
  map.resources :deco_ideas, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/deco_ideas'
  map.resources :deco_services, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/deco_services'


  map.login '/member/ulogin',:controller => 'member', :action => 'ulogin'
  
  map.connect 'deco_firms/name_list', :controller => "deco_firms", :action => "name_list"
  map.connect '/decoration_diary_posts/update_post_state', :controller => 'member/decoration_diary_posts', :action => 'update_post_state'
  
  map.resources :decoration_diaries ,
    :controller =>"member/decoration_diaries",
    :collection =>{ :score => :post, :select_city_area=>:post, :get_deco_firm_id=>:get } do |diary|
    diary.resources :remarks
    diary.resources :decoration_diary_posts,:controller =>"member/decoration_diary_posts"
  end
  map.resources :decoration_diary_posts,
    :controller =>"member/decoration_diary_posts"
  

  map.resources :ad_spaces, :member => {:is_using_change => :get}  #广告位
  
  map.resources :remarks #公司评论
  map.resources :pictures #装修日记图片
  
  map.resources :decoration_diary_labels

  # 以下两条是为了一次市场活动推广加上的，活动结束了就可以去掉了。
  # 活动是：上合家找装修公司 免费入住汉庭
  map.connect '/huodong/xuangongsi', :controller => "activities", :action => 'xuangongsi', :conditions => {:method => :get}
  map.connect '/huodong/register',   :controller => "activities", :action => 'register',   :conditions => {:method => :post}
  
	map.resources :participants
  map.resources :activities do |activity|
  	activity.resources :questions
  end
  map.resources :questions do |question|
  	question.resources :options ,:collection =>{ :set_currect_option=>:post }
  end
  #  map.bardiss 'bardiss', :controller => 'bardiss' ,:path_prefix=>"/huodong"
  map.connect '/huodong/bardiss/:action', :controller => "bardiss"
  #map.root :controller => "activities"
  
  map.resources :categories, :member => {:move => :get, :is_valid => :put, :is_precinct => :put} do |category|
    category.resources :brands, :name_prefix => "category_"
    category.resources :vendors, :name_prefix => "category_"
    category.resources :products, :name_prefix => "category_"
    category.resources :params, :name_prefix => "category_"
    category.resources :properties, :name_prefix => "category_"
    category.resources :experiences, :name_prefix => "category_"
  end

  map.resources :vendors, :member => {:setup => :get, :install => :put, :is_recommend => :put, :is_precinct => :put} do |vendor|
    vendor.resources :deposits, :name_prefix => "vendors_"
    vendor.resources :comments, :name_prefix => "vendors_"
    vendor.resources :vendor_points, :name_prefix => "vendors_"
    vendor.resources :quotes, :name_prefix => "vendors_"
  end
  map.resources :deposits
  map.resources :comments
  map.resources :library_brands
  map.resources :photo_ads
  map.resources :vendor_points
  map.resources :series, :singular => "serie"
  map.resources :quotes
  map.resources :sales_men, :collection => {:destroy_all => :get}
  map.resources :deco_firms_statistics, :only => [:index, :show]

  map.resources :brand_comments, :member => {:is_good => :put,:is_verify => :put}
	map.resources :experiences, :member => {:is_disabled => :put}
  map.resources :brand_experiences, :member => {:setup => :get, :is_disabled => :put}
  map.resources :params, :member => {:move => :get, :is_valid => :put, :is_searchable => :put}
	map.resources :param_items, :member => {:move => :get, :is_valid => :put}
  map.resources :properties, :singluar => "property",:member => {:move => :get}

  map.resources :brands, :member => {:setup => :get, :install => :put, :is_cooperation => :put, :is_hidden => :put, :is_recommend => :put}, 
    :collection => {:update_product => :get, :recommend => :get, :cooperation => :get, :noncooperation => :get, :hidden => :get, :nonhidden => :get, :precinct => :get} do |brand|
    brand.resources :brand_experiences, :name_prefix => "brand_"
    brand.resources :brand_comments, :name_prefix => "brand_"
  end
  
  map.resources :products, :new => {:preview => :post}, 
    :collection => {:operate => :put, :zxj => :get, :special => :get, :auto_complete_belongs_to_for_product_brand_name_zh => :get},
    :member => {:is_sale => :put, :is_recommend => :put, :is_delete => :put, :update_status => :put, :preview => :put, :is_precinct => :put} do |product|
    product.resources :comments, :name_prefix => "product_"
    product.resources :quotes, :name_prefix => "product_"
  end
  map.resources :markets, :collection => {:independent => :get}
  map.resources :json, :singular => "json"
  map.connect '/:pindao/survey/preview', :controller => "survey", :action => "preview"
  map.connect '/:pindao/survey/survey_result', :controller => "survey", :action => "survey_result"
  map.resources :products, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/products'
  map.resources :merchandises, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/merchandises'
  map.resources :brands, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/brands'
  map.resources :promotions, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/promotions'
  map.resources :pricings, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/pricings'
  map.resources :comments, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/comments'
  map.resources :honors, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/honors'
  map.resources :sales, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/sales'
  map.resources :cases, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/cases'
  map.resources :banners, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/banners'
  map.resources :quotes, :name_prefix => 'vendor_', :path_prefix => '/vendor', :controller => 'vendor/quotes'
  map.config '/vendor/config', :controller => "vendor", :action => "edit"

  map.resources :vendors, :name_prefix => 'charge_', :path_prefix => '/charge', :controller => 'charge/vendors'
  map.resources :products, :name_prefix => 'charge_', :path_prefix => '/charge', :controller => 'charge/products', :member => {:move => :get, :is_valid => :put}
  map.resources :promotions, :name_prefix => 'charge_', :path_prefix => '/charge', :controller => 'charge/promotions'
  map.resources :pricings, :name_prefix => 'charge_', :path_prefix => '/charge', :controller => 'charge/pricings'
  map.resources :comments, :name_prefix => 'charge_', :path_prefix => '/charge', :controller => 'charge/comments'

  map.resources :events, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/events' do |event|
    event.resources :registers, :name_prefix => 'event_', :controller => 'decos/registers'
  end
  map.resources :photos, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/photos'
  map.resources :diaries, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/diaries'
  map.resources :registers, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/registers'
  map.resources :quotations, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/quotations'
  map.resources :store_photos, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/store_photos'

  map.resources :glory_certificates, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/glory_certificates'
  map.resources :contacts, :name_prefix => 'deco_', :path_prefix => '/decos', :controller => 'decos/contacts'
  
  map.resources :photos, :name_prefix => 'admin_', :path_prefix => '/admin', :controller => 'admin/photos', :collection => {:operate => :put, :search => :post}
  map.resources :questions, :name_prefix => 'member_', :path_prefix => '/member', :controller => 'member/questions'
  map.resources :quoted_prices 
  map.connect '/member/questions/question_answer', :controller => 'member/questions', :action => 'question_answer'
  
  map.note_relate_to_case_index "/review/note_relate_to_case_index/:diary_id" ,:controller => "review" ,:action =>"note_relate_to_case_index"
  
  map.connect '/zhuanti/:page/index.html', :controller => 'features', :action => 'show'
  #map.root "", :controller => "admin"

  map.resources :bid_records,
    :collection => {:operate_export => :get, :operate_inport => :get, :export_bids => :post, :inport_bids => :post}
  map.connect '/decos/bid_records/:br_id', :controller => 'decos', :action => 'br_show'
  map.connect '/decos/bid_records/:br_id/:tag', :controller => 'decos', :action => 'br_info'

  map.resources :exports,
    :collection => {:guanzhu_dfs => :post, :huoyue_dfs => :post, :diary_votes_summary => :post, :building_names_summary => :post, :export_articles => :post}

	# Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  map.connect '', :controller => "admin", :action => "index"
  map.connect 'admin', :controller => "admin", :action => "index"
  map.connect 'member', :controller => "member", :action => "userinfo"
  map.connect 'vsearch', :controller => "/vendor/vendor_search", :action => "index"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.connect '/deco/image_copy', :controller => "deco", :action => "image_copy"
  map.connect '/deco_ideas/update_idea_name', :controller => "decos/deco_ideas", :action => "update_idea_name"
end
