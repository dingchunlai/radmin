module ApplicantsHelper

  def translate_to_ch(value)
    trans_hash={:id => "编号",:price => "价格",:room => "户型" ,:area => "面积(平米)" ,:budget => "预算",:community => "小区",:name => "户主",:tel => "电话",:status => "状态",:model => "方式",:created_at => "预约时间", :confirm_at => "确认时间", :operation => "操作"}
    trans_hash[value.downcase.to_sym]||value  
  end

end
