class EventController < ApplicationController

  def siemens_shop_index
    @shengfen = params[:shengfen]
    @shengfen = "上海" if @shengfen.to_s.length < 2
    @cities = SiemensShop.find(:all,:select=>"distinct shengfen")
    @rs = SiemensShop.find(:all,:select=>"id,dianpu,dianhua,dizhi",:conditions=>"shengfen = '#{@shengfen}'")
    render :layout => false
  end

  def siemens_shop_js
    @rs = SiemensShop.find(:all,:select=>"id,shengfen,dianpu,dianhua,dizhi",:order=>"shengfen")
    render :layout => false
  end

end
