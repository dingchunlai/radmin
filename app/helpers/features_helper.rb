module FeaturesHelper
  def chanet_callback_image
    image_tag "http://count.chanet.com.cn/action.cgi?t=#{@thank_id}&i=#{@fdatas.id}", :width => 1, :height => 1, :style => 'display:none;' if @external_source
  end
end
