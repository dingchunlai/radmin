class Coupon < Hejia::Db::Product

  set_table_name "product.coupons"

  has_many :coupon_remarks, :as => :resource, :include => :user

  # 根据城市来查询抵用卷信息，按最新来排
  named_scope :with_city_limit, lambda {|city, limit|
    {
      :select => "id, title, city_id",
      :conditions => ["coupons.status = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ? and city_id=?", 1, Time.now, Time.now, city],
      :limit => limit,
      :order => "coupons.activity_began_at DESC"
    }
  }

#  # 按月下载量排行
#  # rails 1.2.5 不支持 group选项 采用find_by_sql方式
#  def self.with_city_downloads(city, limit)
#    now = Time.now
#    beginning_of_month = now.beginning_of_month.strftime("%Y-%m-%d")
#    end_of_month = now.end_of_month.strftime("%Y-%m-%d")
#    now = now.strftime("%Y-%m-%d")
#    sql = "SELECT coupons.id, coupons.title, coupons.city_id, count(coupon_downloads.id) as dld_count FROM coupons join coupon_downloads on coupon_downloads.coupon_id = coupons.id where coupons.city_id=#{city} and coupons.activity_began_at <= '#{now}' and coupons.activity_end_at >='#{now}' and coupon_downloads.created_at >='#{beginning_of_month}' and coupon_downloads.created_at <= '#{end_of_month}' group by coupon_downloads.coupon_id order by dld_count desc limit #{limit}"
#    puts sql
#    find_by_sql(sql)
#  end

  # 按城市随机排
  named_scope :with_city_rand, lambda {|city, limit|
    {
      :select => "id, title, city_id",
      :conditions => ["coupons.status = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ? and city_id=?", 1, Time.now, Time.now, city],
      :limit => limit,
      :order => "rand() DESC"
    }
  }

  # 根据标签来查询抵用卷信息，按下载量来排行
  named_scope :with_tagid_limit, lambda {|tagid, limit|
    {
      :select => "id, title, city_id, (total_issue_number-virtual_existing_number) as def_value",
      :conditions => ["coupons.status = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ? and tag_id=?", 1, Time.now, Time.now, tagid],
      :limit => limit,
      :order => "def_value DESC"
    }
  }

  def url
    "http://#{COUPON_CITIE_PINYIN[city_id]}.youhui.51hejia.com/coupon/#{id}"
  end
  
end