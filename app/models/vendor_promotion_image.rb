class VendorPromotionImage < Hejia::Db::Product
  belongs_to :promotion, :class_name => "VendorPromotion", :foreign_key => "promotion_id"

  has_attachment :content_type => :image,
                   :storage => :file_system,
                   :path_prefix => "public/images/promotions",
                   #:max_size => 500.kilobytes,
                   #:resize_to => '320x200',
                   :thumbnails => { :small => '80x60', :thumb => '150x113>', :medium => '280x210>' },
                   :processor => :Rmagick
  validates_as_attachment
end
