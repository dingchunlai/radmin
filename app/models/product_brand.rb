class ProductBrand < Hejia::Db::Product
  acts_as_list
  
  has_and_belongs_to_many :categories, :class_name => "ProductCategory",
                             :join_table => "product_brands_categories",
                             :foreign_key => "brand_id",
                             :association_foreign_key => "category_id"
  has_and_belongs_to_many :vendors, :class_name => "ProductVendor",
                             :join_table => "product_brands_vendors",
                             :foreign_key => "brand_id",
                             :association_foreign_key => "vendor_id"
  has_many :products, :foreign_key => "brand_id"
  has_many :experiences, :class_name => "BrandExperience", :foreign_key => "brand_id"
  has_one :image, :class_name => "ProductBrandImage", :foreign_key => "brand_id", :dependent => :destroy
  has_many :brand_experiences, :class_name => "ProductBrandExperience", :foreign_key => "brand_id"
  has_many :comments, :class_name => "BrandComment", :foreign_key => "c21"
  has_many :series, :class_name => "ProductSerie", :foreign_key => "brand_id"

  after_update :save_experiences

  GRADES = {
    -1 => '低档',
    0 => '中档',
    1 => '高档',
  }

  #Creating Variable Number of experiences
  def experience_attributes=(experience_attributes)
    experience_attributes.each do |attributes|
      experiences.build(attributes) unless attributes.values.any?(&:blank?)
    end
  end

  def new_experience_attributes=(experience_attributes)
    experience_attributes.each do |attributes|
      experiences.build(attributes) unless attributes.values.any?(&:blank?)
    end
  end

  def existing_experience_attributes=(experience_attributes)
    experiences.reject(&:new_record?).each do |experience|
      attributes = experience_attributes[experience.id.to_s]
      if attributes && !attributes.values.any?(&:blank?)
        experience.attributes = attributes
      else
        experiences.destroy(experience)
      end
    end
  end

  def save_experiences
    experiences.each do |experience|
      experience.save(false)
    end
  end

  def self.initial_brands(item)
    ProductBrand.find(:all, :conditions => ["initial = ?", item])
  end

  def self.popular
    self.find(:all, :order => "view_count desc")
  end

  def self.valid
    self.find(:all, :conditions => ["products_count > 0"])
  end

  def logo
    path = ""
    path << (self.image ? self.image.public_filename(:thumb) : BRAND_DEFAULT_LOGO_PATH)
    return path
  end

  def valid_products
    products.find(:all, :conditions => ["is_delete = ?", false])
  end

  def related_categories_experiences
    first_categories = categories.map{|c| c.parent}.uniq
    first_categories.map{|c| c.experiences}.flatten if first_categories.size > 0
  end

  def owned_first_categories
    categories.map{|c| c.parent}.uniq
  end

  def existing_category_experiences
    experiences.map{|e| e.category_experience}
  end

  def new_category_experiences
    related_categories_experiences - existing_category_experiences
  end

end
