class Product < Hejia::Db::Product
  #acts_as_paranoid

  belongs_to :category, :class_name => "ProductCategory", :foreign_key => "category_id", :counter_cache => true
  belongs_to :vendor, :class_name => "ProductVendor", :foreign_key => "vendor_id", :counter_cache => true
  belongs_to :brand, :class_name => "ProductBrand", :foreign_key => "brand_id", :counter_cache => true
  has_many :images, :class_name => "ProductImage"
  has_one :primary_image, :class_name => "ProductImage", :conditions => ["is_primary = ?", 1]
  has_many :params, :class_name => "ProductParam"
  has_many :properties, :class_name => "ProductProperty"
  has_many :comments, :class_name => "ProductComment", :foreign_key => "product_id"
  has_many :event_logs, :class_name => "EventLog", :as => :entity
  belongs_to :serie, :class_name => "ProductSerie", :foreign_key => "serie_id"
  has_many :quotes, :class_name => "ProductQuote", :foreign_key => "product_id"
  has_many :vendors,:class_name => "ProductVendor", :through => :quotes

  has_and_belongs_to_many :articles,
    :join_table => "51hejia.HEJIA_TAG_ENTITY_LINK",
    :foreign_key => "TAGID",
    :association_foreign_key => "ENTITYID",
    :conditions =>["51hejia.HEJIA_TAG_ENTITY_LINK.LINKTYPE = 'art_prod'"]

  validates_presence_of :name, :category_id, :message => "不能为空！"

  attr_accessor :category_parent_id

  LABELS = {
    'new' => '新品',
    'distinctive' => '特色',
    'classical' => '经典',
  }

  #  acts_as_state_machine :initial => :opened
  #  state :opened
  #  state :closed, :enter => Proc.new {|o| Mailer.send_notice(o)}
  #  state :returned
  #
  #  event :close do
  #    transitions :to => :closed, :from => :opened
  #  end
  #
  #  event :return do
  #    transitions :to => :returned, :from => :closed
  #  end
  after_save :update_vendors
    def update_vendors
      v=self.vendor_id
     unless v.nil?
      self.quotes.each do |q|
        q.destroy unless v.to_s == (q.vendor_id.to_s)
      end
          self.quotes.create(:vendor_id => v) unless v.blank?
      end
      reload
        v= nil
     end
    


  after_update :save_params, :save_images, :save_properties

  #Creating Variable Number of params
  def param_attributes=(param_attributes)
    param_attributes.each do |attributes|
      params.build(attributes) unless attributes.values.all?(&:blank?)
    end
  end

  def new_param_attributes=(param_attributes)
    param_attributes.each do |attributes|
      params.build(attributes) unless attributes.values.all?(&:blank?)
    end
  end

  def existing_param_attributes=(param_attributes)
    params.reject(&:new_record?).each do |param|
      attributes = param_attributes[param.id.to_s]
      if attributes
        param.attributes = attributes
      else
        params.delete(param)
      end
    end
  end

  def save_params
    params.each do |param|
      param.save(false)
    end
  end

  #Creating Variable Number of properties
  def property_attributes=(property_attributes)
    property_attributes.each do |attributes|
      properties.build(attributes) unless attributes.values.all?(&:blank?)
    end
  end

  def new_property_attributes=(property_attributes)
    property_attributes.each do |attributes|
      a = attributes[:value]
      #      properties.build(attributes) unless attributes.values.all?(&:blank?)
      properties.build(attributes) if !a.blank?
    end
  end

  def existing_property_attributes=(property_attributes)
    properties.reject(&:new_record?).each do |property|
      attributes = property_attributes[property.id.to_s]
      if !attributes[:value].blank?
        property.attributes = attributes
      else
        properties.delete(property)
      end
    end
  end

  def save_properties
    properties.each do |property|
      property.save(false)
    end
  end

  #Creating Variable Number of images
  def image_attributes=(image_attributes)
    image_attributes.each do |attributes|
      images.build(attributes) unless attributes.values.all?(&:blank?)
    end
  end

  def new_image_attributes=(image_attributes)
    image_attributes.each do |attributes|
      images.build(attributes) unless attributes.values.all?(&:blank?)
    end
  end

  def existing_image_attributes=(image_attributes)
    images.reject(&:new_record?).each do |image|
      attributes = image_attributes[image.id.to_s]
      if attributes
        image.attributes = attributes
        #else
        #  images.delete(image)
      end
    end
  end

  def save_images
    images.each do |image|
      image.save(false)
    end
  end

  def hot_products(num)
    if self.vendor
      self.vendor.products.find(:all, :conditions => ["id != ?", self.id], :limit => num, :order => "marking desc")
    else
      []
    end
  end

  def primary_image_path(thumbnail = nil)
    primary_image ? primary_image.full_path(thumbnail) : PRODUCT_DEFAULT_PRIMARY_IMAGE_PATH
  end

  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, *partitioned_path(thumbnail_name_for(thumbnail)))
  end

  def common_images
    images.find(:all, :conditions => ["is_primary = ?", "0"])
  end

  def self.direct_products
    self.find(:all, :conditions => ["typehood = ?", 1])
  end

  def log_event(permalink, user_id)
    event = Event.find(:first, :conditions => ["permalink = ?", permalink])

    if event
      self.event_logs.build(:event_id => event.id, :user_id => user_id)
      self.point += event.point
      self.save
    end
  end
  
  def self.get_brand_by_tagid(id)
    key = "product_tagid_#{id}_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    ProductBrand
    if CACHE.get(key).nil?
        t = ProductBrand.find_by_sql("select b.* from product_brands as b ,product_brands_categories as c where c.category_id=#{id} and b.id=brand_id order by initial asc ")
        tag = t
        CACHE.set(key, tag)
    else
        tag = CACHE.get(key)
    end
    return tag
  end
  
end

