# == Schema Information
#
# Table name: photo_tags
#
#  id         :integer(11)     not null, primary key
#  name       :string(255)
#  parent_id  :integer(11)
#  created_at :datetime
#  updated_at :datetime
#

class PhotoTag < ActiveRecord::Base
  self.table_name = "photo_tags"
  self.primary_key = "id"


  acts_as_tree :foreign_key => "parent_id"
  

  def self.get_id_by_name(name)
    r = self.find(:first,:select=>"id",:conditions=>["name = ?", name])
    if r.nil?
       tag = self.new()
       tag.name = name
      
       return tag.id if tag.save
    else
      return r["id"].to_i
    end
  end
   


  def self.get_name_by_id(id)
    r = self.find(:first,:select=>"name",:conditions=>["id = ?",id])
    if r.nil?
      return ""
    else
      return r["name"]
    end
  end
  

end
