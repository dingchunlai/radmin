class Bid < ActiveRecord::Base
  CITY = [["上海","11910"],["宁波","12301"],["无锡","12118"],["杭州","12306"],["南京","12122"],["苏州","12117"],["武汉","12093"],["青岛","12173"]]

  belongs_to :bid_record
  belongs_to :deco_firm

  validates_numericality_of :bid_price

  def tag_name
    if price
      BidRecord::PRICE.values_at(price)
    else
      BidRecord::STYLE.values_at(style)
    end
  end

end
