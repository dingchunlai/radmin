module QuotedPricesHelper

  def translate_to_chinese(value)
    trans_hash={:id => "编号",:price => "价格",:room => "户型" ,:area => "平米" ,:deco_type => "类型" }
    trans_hash[value.downcase.to_sym]||value  
  end

end

