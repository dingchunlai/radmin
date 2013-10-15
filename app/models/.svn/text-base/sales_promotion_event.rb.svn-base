class SalesPromotionEvent < Hejia::Db::Product
  def title
    read_attribute("subject")
  end

  def url
    "http://www.51hejia.com/huodong/#{id}"
  end

  class << self

    def unexpired_events(limit, city = '')
      max_limit = 10
      fail '参数limit不能大于max_limit' if limit > max_limit
      memkey = "sales_promotion_event_unexpired_events_2_#{max_limit}_#{city}"
      events = PUBLISH_CACHE.fetch(memkey, 3.hours) do
        cond = ["ends_at >= '#{Time.now.to_s(:db)}'"]
        cond << "city = '#{city}'" unless city.blank?
        SalesPromotionEvent.find(:all,:select => 'id,subject,city',
          :conditions => cond.join(' and '),
          :order => "ends_at asc",
          :limit => max_limit)
      end
      events[0...limit]
    end

  end

end
