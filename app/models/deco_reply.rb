# == Schema Information
#
# Table name: 51hejia.radmin_fdatas
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

class DecoReply < ActiveRecord::Base
  self.table_name = "51hejia.radmin_fdatas"
  
  alias_attribute :review_id, :c1                 #回应的评论id
  alias_attribute :user_id, :c2                   #回应人id
  alias_attribute :replytype, :c3                 #回应类型(1:回应，2：举报)
  alias_attribute :username, :c4                  #用户名
  alias_attribute :userurl, :c5                   #用户头像
  alias_attribute :content, :c30                  #评论内容    
  alias_attribute :type, :c34                     #标记活动 1, 活动 2,报价单回应
  belongs_to :user,
  :class_name => "HejiaUserBbs",
  :foreign_key => "c2"
  
  belongs_to :review,
  :class_name => "DecoReview",
  :foreign_key => "c1"
  
  belongs_to :event,
  :class_name => "DecoEvent",
  :foreign_key => "c1"
  
  belongs_to :quotation,
  :class_name => "DecoQuotation",
  :foreign_key => "c1"
  
 
  def self.getreplies(reviewid,replytype) 
    return DecoReply.find(:all,:conditions=>"formid = '#{HUIFU_ID}' and c1 = '#{reviewid}' and c3 = '#{replytype}' ")
  end 
  
end

