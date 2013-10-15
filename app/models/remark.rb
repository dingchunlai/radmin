# == Schema Information
#
# Table name: remarks
#
#  id            :integer(11)     not null, primary key
#  user_id       :integer(11)
#  ip            :string(255)
#  content       :text
#  created_at    :datetime
#  updated_at    :datetime
#  resource_type :string(255)
#  resource_id   :integer(11)
#  parent_id     :integer(11)
#

class Remark < Hejia::Db::Hejia
  belongs_to :resource, :polymorphic => true
  belongs_to :hejia_user_bbs, :class_name => "HejiaUserBbs", :foreign_key => "user_id"
  belongs_to :decorationn_diary, :class_name => "DecorationDiary", :foreign_key => "other_id"
  has_many :replies, :class_name => "Remark",  :foreign_key => "parent_id", :dependent => :destroy 
  after_create  :increase_remark_only_count
  after_destroy :decrease_remark_only_count
  
  validates_presence_of :user_id
  
  has_finder :praised, :conditions => "praise > 0"
  
  def self.getcompanycomments(id)
    Remark.find(:all,:conditions => "resource_id=#{id}").size
  end

  # remark_only_count是用来记录留言数的缓存。
  # 留言的回复不被计算在内
  def increase_remark_only_count
    if self.resource.class == DecorationDiary
      diary = self.resource.decoration_diary
      diary.remarks_count += 1
      diary.save
    end
  end
  private :increase_remark_only_count

  def decrease_remark_only_count
    if self.resource.class == DecorationDiary
      diary = self.resource.decoration_diary
      diary.remarks_count -= 1
      diary.save
    end
  end
  private :decrease_remark_only_count
end
