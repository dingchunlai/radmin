# == Schema Information
#
# Table name: article_infos
#
#  id              :integer(11)     not null, primary key
#  title           :string(255)     default(""), not null
#  content         :text
#  image           :string(45)
#  article_urls_id :integer(11)
#  created_at      :datetime
#  updated_at      :datetime
#  added_status    :integer(4)      default(0)
#

class ArticleInfo < ActiveRecord::Base
  def self.total_entries
    cache_key = Digest::MD5.hexdigest("article_info index total_entries")
    find_count = ""
    if CACHE.get(cache_key).blank?
      find_count = find_by_sql("SELECT count(*) AS count_all FROM article_infos")[0].count_all
      CACHE.set(cache_key, find_count)
    end
    CACHE.get(cache_key) || find_count
  end

end
