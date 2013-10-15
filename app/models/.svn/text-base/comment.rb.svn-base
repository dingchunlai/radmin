# == Schema Information
#
# Table name: radmin_comments
#
#  id         :integer(11)     not null, primary key
#  theme_id   :integer(11)     default(0), not null
#  sort_id    :integer(11)     default(0), not null
#  nickname   :string(64)
#  content    :string(512)
#  reply      :string(512)
#  created_at :datetime
#  updated_at :datetime
#  is_delete  :integer(4)      default(0), not null
#  pv1        :integer(4)
#  pv2        :integer(4)
#  pv3        :integer(4)
#  pv4        :integer(4)
#  pv5        :integer(4)
#  pv6        :integer(4)
#  pv7        :integer(4)
#  flag       :integer(4)      default(0), not null
#  parent_id  :integer(4)      default(0), not null
#

# -*- coding: utf-8 -*-
class Comment < ActiveRecord::Base
  self.table_name = "radmin_comments"
  belongs_to :hejiacase, :class_name=>"HejiaCase", :foreign_key=>"theme_id"
end
