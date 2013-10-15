class BidRecord < ActiveRecord::Base
  PRICE = {1 => '8万以下',2 => '8-15万',3 => '15-30万',4 => '30万-100万',5 => '100万以上'}

  STYLE = {1 => '现代简约',2 => '田园风格',3 => '欧美式',4 => '中式风格',5 => '地中海',6 => '混搭'}

  has_many :bids


  def radmin_bids(type = "PRICE", value = 1)
    if type == "PRICE"
      Bid.find(:all, :conditions => ["bid_record_id = ? and price = ?", self.id, value], :order => "price desc")
    else
      Bid.find(:all, :conditions => ["bid_record_id = ? and style = ?", self.id, value], :order => "price desc")
    end
  end
end
