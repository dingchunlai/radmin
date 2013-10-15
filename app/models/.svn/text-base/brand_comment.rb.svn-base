# == Schema Information
#
# Table name: radmin_fdatas
#
#  id       :integer(11)     not null, primary key
#  formid   :integer(11)     not null
#  userip   :string(15)
#  status   :integer(4)      default(0), not null
#  isdelete :(1)             default("\000"), not null
#  cdate    :datetime
#  udate    :datetime
#  ptime    :datetime
#  c1       :string(512)
#  c2       :string(512)
#  c3       :string(512)
#  c4       :string(512)
#  c5       :string(512)
#  c6       :string(512)
#  c7       :string(512)
#  c8       :string(512)
#  c9       :string(512)
#  c10      :string(512)
#  c11      :string(512)
#  c12      :string(512)
#  c13      :string(512)
#  c14      :string(512)
#  c15      :string(512)
#  c16      :string(512)
#  c17      :string(512)
#  c18      :string(512)
#  c19      :string(512)
#  c20      :string(127)
#  c21      :integer(11)
#  c22      :integer(11)
#  c23      :integer(11)
#  c24      :integer(11)
#  c25      :integer(11)
#  c26      :integer(11)
#  c27      :integer(11)
#  c28      :integer(11)
#  c29      :integer(11)
#  c30      :text
#  remark   :string(512)
#  area     :string(8)
#  c31      :integer(11)
#  c32      :integer(11)
#  c33      :integer(11)
#  c34      :integer(11)
#  c35      :integer(11)
#

class BrandComment < ActiveRecord::Base
  self.table_name = "radmin_fdatas"

  belongs_to :brand, :class_name => "ProductBrand", :foreign_key => "c21"
  belongs_to :user, :class_name => "HejiaUserBbs", :foreign_key => "c22"

  def self.brand_use_count(brand_id, use_id)
    use_form_id = 84
    BrandComment.count :conditions => "formid = #{use_form_id} and c21 = #{brand_id} and c23 = #{use_id}"
  end

  def self.brand_rating_count(brand_id, rating_value)
    comment_form_id = 83
    BrandComment.count :conditions => "formid = #{comment_form_id} and c21 = #{brand_id} and c24 = #{rating_value}"
  end
end
