# == Schema Information
#
# Table name: deco_firms
#
#  id                       :integer(11)     not null, primary key
#  user_id                  :integer(11)
#  name_zh                  :string(255)
#  name_en                  :string(255)
#  name_abbr                :string(255)
#  logo_file_name           :string(255)
#  business_hours           :string(255)
#  is_cooperation           :boolean(1)
#  model                    :integer(11)
#  style                    :integer(11)
#  summary                  :text
#  detail                   :text
#  website                  :string(255)
#  email                    :string(255)
#  linkman                  :string(255)
#  telephone                :string(255)
#  fax                      :string(255)
#  msn                      :string(255)
#  qq                       :string(255)
#  city                     :integer(11)
#  district                 :integer(11)
#  address                  :string(255)
#  lat                      :float
#  lng                      :float
#  postcode                 :integer(11)
#  traffic                  :string(255)
#  position                 :integer(11)
#  state                    :string(255)
#  lowest_quotation         :integer(11)
#  offer_title              :string(255)
#  offer_content            :text
#  service_content          :text
#  budget_file_name         :string(255)
#  verysatisfied            :integer(11)
#  satisfied                :integer(11)
#  unsatisfied              :integer(11)
#  total_score              :float
#  design_score             :float
#  budget_score             :float
#  construction_score       :float
#  service_score            :float
#  comments_count           :integer(11)
#  digest_comments_count    :integer(11)
#  latest_comments_count    :integer(11)
#  complaint_comments_count :integer(11)
#  bookings_count           :integer(11)
#  worksites_count          :integer(11)
#  cases_count              :integer(11)
#  designers_count          :integer(11)
#  photos_count             :integer(11)
#  created_at               :datetime
#  updated_at               :datetime
#  subbranch                :text
#  pricetese                :string(30)
#  styletese                :string(30)
#  methodtese               :string(30)
#  orderindex               :string(10)
#  source_type              :integer(4)
#  total_score_new          :float
#  design_score_new         :float
#  budget_score_new         :float
#  construction_score_new   :float
#  service_score_new        :float
#  pv_count                 :integer(11)     default(0)
#  area                     :integer(11)
#  freedesign               :integer(11)
#  freelook                 :integer(11)
#  freedo                   :integer(11)
#  ordertime                :datetime
#  star                     :float
#  star_lest                :float
#  address2                 :string(255)
#  random_order             :integer(11)
#

class DecoFirm < Hejia::Db::Hejia


  attr_accessor :is_need_send_msg
  
  has_many :deco_ideas
  has_many :deco_services
  has_attached_file :logo,
    :path => ":rails_root/public/files/companylogo/:basename.:extension",
    :url => "/files/companylogo/:basename.:extension",
    :default_url => "/images/missing.gif"
  has_attached_file :budget,
    :path => ":rails_root/public/decos/:class/:attachment/:id/:basename.:extension",
    :url => "/decos/:class/:attachment/:id/:basename.:extension"

  acts_as_mappable
  before_validation :geocode_address
  has_many :rad_factories, :class_name => "DecoFactory", :foreign_key => "COMPANYID"
  #has_many :designers, :class_name => "DecoDesigner", :foreign_key => "firm_id"
  #has_many :worksites, :class_name => "DecoWorksite", :foreign_key => "companyid"
  #has_many :comments, :class_name => "DecoComment", :foreign_key => "firm_id"
  #has_many :bookings, :class_name => "DecoBooking", :foreign_key => "firm_id"
  has_many :quoted_prices
  has_many :applicants
  has_many :store_photos
  has_many :glory_certificates

  def self.getfirm(id)
    CACHE.fetch("firms/id/#{id}", RAILS_ENV == 'production' ? 1.hour : 1) do
      find_by_id(id,:include=>:pictures)
    end
  end
  
  def self.valid_firms
    find(:all, :conditions => ["city = 11910 and address is not null and (lng is null or lat is null)"])
  end

  def self.getcity(id)
    if !id.nil?&&id.to_i!=0
      tagname = "decofirm_tag_tag_tagname_city_key_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
      if CACHE.get(tagname).nil?
        t = ArticleTag.find(id)
        tag = t.TAGNAME
        CACHE.set(tagname, tag)
      else
        tag = CACHE.get(tagname)
      end
      return tag
    else
      return "无城市"
    end
  end
  
  def self.getarea(id)
    if !id.nil?&&id.to_i!=0
      tagname = "decofirm_tag_tag_tagname_area_key_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
      if CACHE.get(tagname).nil?
        t = ArticleTag.find(id)
        tag = t.TAGNAME
        CACHE.set(tagname, tag)
      else
        tag = CACHE.get(tagname)
      end
      return tag
    else
      return "无地区"
    end
  end
  
  def self.getcase(id)
    if !id.nil?&&id.to_i!=0
      tagname = "decofirm_case_bycompanyid_key_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
      if CACHE.get(tagname).nil?
        tag = DecoCase.count(:id,:conditions=>"COMPANYID =#{id}")
        CACHE.set(tagname, tag)
      else
        tag = CACHE.get(tagname)
      end
      return tag
    else
      return 0
    end
  end
  
  def self.getdesigner(id)
    if !id.nil?&&id.to_i!=0
      tagname = "decofirm_designer_bycompanyid_key_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
      if CACHE.get(tagname).nil?
        tag = DecoDesigner.count(:id,:conditions=>"COMPANY =#{id}")
        CACHE.set(tagname, tag)
      else
        tag = CACHE.get(tagname)
      end
      return tag
    else
      return 0
    end
  end
  
  def self.getphoto(id)
    if !id.nil?&&id.to_i!=0
      tagname = "decofirm_case_deco_photos_key_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
      if CACHE.get(tagname).nil?
        tag = DecoPhoto.count(:id,:conditions=>"entity_type='DecoFirm' and entity_id=#{id}")
        CACHE.set(tagname, tag)
      else
        tag = CACHE.get(tagname)
      end
      return tag
    else
      return 0
    end
  end
  
  #获得所有点评
  def self.get_all_decofirms
    result = DecoFirm.find(:all,:select => "id,pv_count",:conditions => "state <> '-100'")
    return result
  end
  
  def self.get_deco_firm_by_name(name)
    n = name.gsub(" ","")
    key = "zhaozhuangxiu_get_deco_firm_by_name_#{Time.now.strftime('%Y%m%d%H')}_#{n}1"
    result = nil
    conditions = []
    conditions << "state is not null and state <> '-100'" 
    conditions << "name_zh like'%#{name}%'" if name && name != ''
    if CACHE.get(key).nil?
      result = find(:all,:conditions=>conditions.join(" and ") ,:order => "total_score desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end
  
  #创建日记时查找日记对应的公司
  def self.get_deco_firms(name,city)
    CACHE.fetch("get/diary/firm/for/city_id/praise/#{city}/#{name}",1.hours) do
      conditions = []
      conditions << "(state <> '-100' and state <> '-99')" 
      if !city.nil?
         city_condition = (city.to_i == 11910 || city.to_i == 11905 || city.to_i == 31959) ? "city = #{city}" : "district = #{city}"
         conditions << city_condition
      end
      conditions << "name_zh like '%#{name}%'" if name && name != ''
      DecoFirm.find(:all,
                    :select => "id,name_zh",
                    :conditions=>conditions.join(" and "),
                    :order => "is_cooperation desc,praise desc"
                    )
    end
  end
  
  def self.get_deco_firms_by_city(city)
    key = "zhaozhuangxiu1_get_deco_firms_by_city_#{Time.now.strftime('%Y%m%d%H')}_#{city}_#{city}_#{city}_2"
    result = nil
    conditions = []
    conditions << "state is not null" 
    if city.to_i==11910 or city.to_i == 11905 or city.to_i == 31959
      conditions << "city=#{city}"
    else
      conditions << "district=#{city}" 
    end
    if CACHE.get(key).nil?
      result = find(:all,:select => "id,name_zh,pv_count",:conditions=>conditions.join(" and ") ,:order => "id desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end

  def  self.find_firm(deco_id)
    #    @firm = DecoFirm.find(7)
    unless deco_id.nil? || deco_id == 0
      firm = DecoFirm.find(deco_id.to_i)
      logger.info "log in status *****************************************************"
      logger.info deco_id
      return firm
    else
      #flash[:notice] = "请登录！"
      logger.info "log out status *****************************************************"
      return nil
    end
  end

  def full_address
     if city.to_i == 11910
      "上海市#{address} "  #因以前很多上海地区地址的数据只写了XX路,所以加上海市(如果重复出现两个上海市，不影响生成的经纬数据)
    else
      address
    end
  end

  def sync_geocode
    self.geocode_address
    self.save
  end

  #private
  def geocode_address
    if lat.blank? || lng.blank?
      geo = GeoKit::Geocoders::MultiGeocoder.geocode(full_address)
      errors.add(:address, "Could not Geocode address") if !geo.success
      self.lat, self.lng = geo.lat,geo.lng if geo.success
    end
  end
	
	# 此方法2010-10-1以后可删除
	def calculate_star(score)
	  if %w[1 -1].include?(is_cooperation_before_type_cast)
	    star = JfBase.find(:first, :select => 'value', :conditions => ["keyword = 'C1' and ? between start_num and end_num", score]).value.to_i
	     city == 11910 ? star : star += 2 
	  else
	    0
	  end
	end
	
	# 此方法2010-10-1以后可删除
	def show_pv_score
	  # 采用新算分规则的时间
    date = '2010-05-29'

    # 所有通过审核的日记
    diaries = DecorationDiary.find(
      :all,
      :select => 'pv',
	    :conditions => ["deco_firm_id = ? and status = 1 and created_at >= ?", self.id,date]
    )
    score = 0 
     diaries.each do |diary|
        # 通过审核的每一篇日记：
        # * 留言（包括留言和回复）量，每50个算1分
        # * 浏览量，每4000篇算1分
        score += diary["pv"] / 4000
     end
   score
    
	end
	
  # 计算公司的积分。
  # 这是第二版计算规则。
  # 基于各种考虑，各公司先按照第一版的计算规则把截止到2010年5月29号的分数计算出来，报存在公司表中（使用design_score, service_score等字段）。
  # 这一版的规则就只作用于2010年5月29号之后（包括该天）的数据。
  # 公司的总分，则是把计算出来的新分数，加上旧的分数。
  # 此方法2010-10-1以后可删除
	def calculate_score
    # 采用新算分规则的时间
    date = '2010-05-29'

    # 所有通过审核的日记
    diaries = decoration_diaries.find(
      :all,
      :select => 'design_score, construction_score, service_score, remarks_count, pv, is_verified',
	    :conditions => ["status = 1 and created_at >= ?", date]
    )

    # 通过审核的日记，1篇算2分
    score = diaries.size * 2

    # 各项细分（设计、施工、服务）
    design_score, construction_score, service_score =
      self.design_score, self.construction_score, self.service_score

    # 日记总浏览量
    pv_count = 0

    diaries.each do |diary|
      # 通过审核的每一篇日记：
      # * 留言（包括留言和回复）量，每50个算1分
      # * 浏览量，每4000篇算1分
      score += diary.remarks_count / 50
      score += diary["pv"] / 4000

      pv_count += diary["pv"]

      # 计算各篇日记的设计、施工、服务打分
      # 通过认证的日记，每项打分各乘以5
      # 没有通过认证的日记，每项打分就按照原分值处理
      weight = diary.verified? && 5 || 1
      design_score       += (diary.design_score || 0) * weight
      construction_score += (diary.construction_score || 0) * weight
      service_score      += (diary.service_score || 0) * weight
    end

    # 总分
    score += design_score + construction_score + service_score
    # 加上修正分之后的总分
    adjusted_score = score + self.adjusted_score

    # 把修正分，按比例，分别添加到设计、施工、服务三个分数上
    # TODO 这段逻辑在ReviewController#update_this_adjusted_score也有，应该统一一下。统一之前，如果逻辑有修改，注意__同步__！
    adjusted_scores =
      if score == 0
        [self.adjusted_score / 3] * 3
      else
        adjusted_design_score       = (self.adjusted_score * design_score / score).floor # 这里不能用round，否则总和会变大(如果全部都是五入的话)
        adjusted_construction_score = (self.adjusted_score * construction_score / score).floor
        adjusted_service_score      = self.adjusted_score - adjusted_design_score - adjusted_construction_score

        [adjusted_design_score, adjusted_construction_score, adjusted_service_score]
      end.zip([design_score, construction_score, service_score]).map! { |a, b| a + b }
    
    
    #计算公司星级 新规则 于2010年6月17日启用
    star = calculate_star(adjusted_score)
    #计算公司星级 旧规则
    #star = DecoReview.get_star_score(self, adjusted_score)

    # 把各项分值更新到数据库中
    self.class.update_all(
      "design_score_new = #{design_score}," +
      "adjusted_design_score = #{adjusted_scores[0]}," +
      "construction_score_new = #{construction_score}," +
      "adjusted_construction_score = #{adjusted_scores[1]}," +
      "service_score_new = #{service_score}," +
      "adjusted_service_score = #{adjusted_scores[2]}," +
      "nonadjusted_score = #{score}," +
      "total_score_new = #{adjusted_score}," +
      "star = #{star}",
      :id => id
    )
	end
	
	def self.all_praise_firm_id
	  firm_ids = DecoFirm.find_by_sql(%{
	    (select distinct deco_firm_id as firm_id from decoration_diaries where praise > 0)
      union all
      (select distinct resource_id as firm_id from remarks where praise > 0)}).map(&:firm_id).uniq
	end
  
  # 用于显示用的设计分，四舍五入取整
  def int_design_score
    adjusted_design_score.round
  end

  # 用于显示用的施工分，四舍五入取整
  def int_construction_score
    adjusted_construction_score.round
  end

  # 用于显示用的服务分，四舍五入取整
  def int_service_score
    adjusted_service_score.round
  end

  def self.show_firm_name_zh(firm_id)
    firm_name = DecoFirm.find(firm_id).name_zh
    firm_name.nil? ? "未命名" : firm_name
  end

end
