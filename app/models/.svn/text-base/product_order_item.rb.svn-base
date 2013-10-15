class ProductOrderItem < Hejia::Db::Product
  belongs_to :order, :class_name => "ProductOrder", :foreign_key => "order_id"
  belongs_to :product, :class_name => "Product", :foreign_key => "product_id"

  validates_inclusion_of :status, :in => [0,1,2,3,4,5]

  def validate
    errors.add(:amount, "数量至少为一个！") unless amount.nil? || amount > 0
    errors.add(:price, "价格应该为整数！") unless price.nil? || price > 0.0
  end

  def subtotal
    price * amount
  end

  def self.undone_items(cookies)
    find(:all, :include => [:order], :conditions => ["product_orders.user_id = ? and product_order_items.status in (?)", cookies, [0, 1]], :order => "product_order_items.created_at desc")
  end

  def self.done_items(cookies)
    find(:all, :include => [:order], :conditions => ["product_orders.user_id = ? and product_order_items.status in (?)", cookies, [2, 3, 4]], :order => "product_order_items.created_at desc")
  end

end
