# == Schema Information
#
# Table name: deco_photos
#
#  id                 :integer(11)     not null, primary key
#  title              :string(255)
#  summary            :text
#  is_certificated    :boolean(1)
#  entity_id          :integer(11)
#  entity_type        :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(11)
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  phototype          :integer(4)      default(0)
#

class DecoPhoto < Hejia::Db::Hejia
  has_attached_file :image, :styles => { :original => "500x375>",:thumb => "105x80>", :medium => "160x120" },
    :path => ":rails_root/public/decos/:class/:attachment/:id/:basename_:style.:extension",
    :url => "/decos/:class/:attachment/:id/:basename_:style.:extension",
    :default_url => "/images/missing.gif"

  belongs_to :firm, :class_name => "DecoFirm", :foreign_key => "entity_id"
  belongs_to :entity, :polymorphic => true
end
