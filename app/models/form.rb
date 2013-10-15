# == Schema Information
#
# Table name: radmin_forms
#
#  id              :integer(11)     not null, primary key
#  title           :string(255)
#  remark          :string(999)
#  forward         :string(255)
#  status          :integer(4)      default(1), not null
#  cnum            :integer(4)      default(0), not null
#  cdate           :date
#  udate           :date
#  isdelete        :integer(4)      default(0), not null
#  department      :integer(11)     default(0), not null
#  alert           :string(128)
#  submit_interval :integer(11)
#

class Form < ActiveRecord::Base
  has_many :fdatas #, :finder_sql => ""
  self.table_name = "radmin_forms"
  def self.update_cnum(id)
      f = Form.find(id, :select => "id, cnum")
      f.cnum = Column.count("id", :conditions => "formid = #{id}")
      f.save
  end
end
