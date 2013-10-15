class ProductOrder < Hejia::Db::Product
  attr_protected :id, :customer_ip, :status, :error_message, :updated_at, :created_at

  has_many :order_items, :class_name => "ProductOrderItem", :foreign_key => "order_id"
  has_many :products, :through => :order_items, :class_name => "ProductOrderItem", :foreign_key => "product_id"

  validates_length_of :telephone, :in => 7..20
  #validates_length_of :cellphone, :in => 7..20
  validates_length_of :customer_ip, :in => 7..15
  #validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_inclusion_of :status, :in => [0,1,2,3,4,5]

  def total
    order_items.inject(0){|sum, n| n.price * n.amount + sum}
  end

  def opened
    self.status = 0
    save!
  end


end
