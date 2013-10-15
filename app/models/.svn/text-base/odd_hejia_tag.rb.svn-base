# == Schema Information
#
# Table name: HEJIA_TAG
#
#  TAGID       :integer(19)     not null, primary key
#  TAGFATHERID :integer(19)     not null
#  TAGNAME     :string(510)     default(""), not null
#  TAGVALUE    :string(4000)
#  TAGICON     :string(510)
#  TAGURL      :string(510)
#  TAGTAXIS    :integer(19)
#  TAGESTATE   :string(510)     default(""), not null
#  TAGDATE     :datetime
#  TAGCODE     :string(510)
#  TAGTYPE     :string(510)
#  BIDDING     :integer(11)
#  SPELL       :string(255)
#  TEMPURL     :string(255)
#  VERSION     :string(255)
#  TAGCOMMENT  :string(255)
#  ISIMPORTANT :boolean(1)
#

class OddHejiaTag < ActiveRecord::Base
  self.table_name = "HEJIA_TAG"
  self.primary_key = "TAGID"
end
