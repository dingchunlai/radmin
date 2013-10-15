class ProductCategory < Hejia::Db::Product
  acts_as_tree :order => "position"
  acts_as_list :scope => :parent
  has_and_belongs_to_many :brands, :class_name => "ProductBrand",
                             :join_table => "product_brands_categories",
                             :foreign_key => "category_id",
                             :association_foreign_key => "brand_id"
  has_and_belongs_to_many :vendors, :class_name => "ProductVendor",
                             :join_table => "product_categories_vendors",
                             :foreign_key => "category_id",
                             :association_foreign_key => "vendor_id"
  has_many :products, :foreign_key => "category_id", :conditions => ["products.is_delete = ?", false]
  has_many :direct_products, :class_name => "Product",:foreign_key => "category_id", :conditions => ["typehood = ?", 1], :order => "products.public_praise desc"
  has_many :pricing_products, :class_name => "Product",:foreign_key => "category_id", :conditions => ["typehood = ?", 0], :order => "products.public_praise desc"
  has_many :params, :class_name => "ProductCategoryParam", :foreign_key => "category_id", :conditions => ['`key` not LIKE ? ', "%无效%" ]
  has_many :properties, :class_name => "ProductCategoryProperty", :foreign_key => "category_id"
  has_many :experiences, :class_name => "ProductCategoryExperience", :foreign_key => "category_id"
  has_many :brand_experiences, :class_name => "ProductBrandExperience", :foreign_key => "category_id"

  def self.first_class
    ProductCategory.find(:all, :conditions => ["parent_id = ? and is_valid = ?", 1, 0], :order => "position")
  end

  def self.second_class
    ProductCategory.find(:all, :conditions => ["parent_id != ? and is_valid = ?", 1 || null, 0], :order => "position")
  end

  def valid_children
    children.find(:all, :conditions => ["is_valid = ?", 0])
  end

  def owned_products
    if valid_children.any?
      #valid_children.collect { |c| c.products }.flatten!
      Product.find_by_sql ["select * from products where category_id in (?) and products.is_delete is false order by public_praise desc", valid_children]
    else
      products
    end
  end

  def owned_products_count
    if valid_children.any?
      children.inject(0) {|sum, c| c.products_count + sum}
    else
      products_count
    end
  end

  def direct_owned_products
    if valid_children.any?
      valid_children.collect { |c| c.direct_products }.flatten!
    else
      direct_products
    end
  end

  def pricing_owned_products
    if valid_children.any?
      valid_children.collect { |c| c.pricing_products }.flatten!
    else
      direct_products
    end
  end

  def chart_products
    self.owned_products[0, 10]
  end

  def owned_vendors
    if valid_children.any?
      valid_children.collect { |c| c.vendors }.flatten!.uniq
    else
      vendors
    end
  end

  def owned_brands
    if valid_children.any?
      valid_children.collect { |c| c.brands }.flatten!.uniq
    else
      brands
    end
  end

  def cooperation_brands
    if valid_children.any?
      valid_children.collect { |c| c.brands.find(:all, :conditions => ["is_cooperation = ? and is_hidden = ?", true, false]) }.flatten!.uniq
    else
      brands.find(:all, :conditions => ["is_cooperation = ? and is_hidden = ?", true, false])
    end
  end

  def normal_brands
    if valid_children.any?
      valid_children.collect { |c| c.brands.find(:all, :conditions => ["is_cooperation = ? and is_hidden = ?", false, false]) }.flatten!.uniq
    else
      brands.find(:all, :conditions => ["is_cooperation = ? and is_hidden = ?", false, false])
    end
  end

  def owned_params
    if valid_children.any?
      valid_children.collect { |c| c.params }.flatten!
    else
      params
    end
  end

  def owned_properties
    if valid_children.any?
      valid_children.collect { |c| c.properties }.flatten!
    else
      properties
    end
  end
  def vendor_direct_products
    if valid_children.any?
      valid_children.collect { |c| c.direct_products }.flatten!
    else
      direct_products
    end
  end

  def sibling
    if valid_children.any?
      ProductCategory.first_class.find(:all, :conditions => ["id != ?", self.id])
    else
      parent.valid_children
    end
  end

  def related_products(num)
    products.find(:all, :conditions => ["products.id != ?", self.id], :limit => num, :order => "public_praise desc")
  end

  def self.first_sale_class
    ProductCategory.find(:all, :conditions => ["parent_id = ? and is_valid = ? and tagid not in (13129,13155,12954,33062)", 1, 0], :order => "position")
  end

  def valid_sale_children
    children.find(:all, :conditions => ["is_valid = ? and products_count > ?", 0, 0])
  end

  def sale_products
    products.find(:all, :conditions => ["typehood != 1 or typehood is null"], :limit => 4, :order => "liveness desc")
  end

  def valid_products
    products.find(:all, :conditions => ["is_delete = ?", false])
  end

  #大分类 -- type1 :controller => article , :action => new
  def self.type1list
    find(:all, :conditions => ["parent_id = ?", 1])
  end
end
