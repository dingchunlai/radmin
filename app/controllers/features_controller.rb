# 需要动态功能的专题
class FeaturesController < ApplicationController
  def show
    action = :"#{params[:page]}"
    if private_methods.include?(action.to_s) || private_methods.include?(action)
      send action 
    else
      render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => 404
    end
  end

  private

  # 显示跟成果网（chanet）合作的专题页面
  def show_chanet_page(options)
    if (fdatas_id = params[:f]) && @fdatas = Fdata.find_by_id(fdatas_id)
      if @fdatas[options[:column]] == '爱德威'
        @external_source = true
        @thank_id = options[:thank_id]
      end
    end

    render :template => "features/#{params[:page]}"
  end

  # 各个跟成果网合作的专题
  def jinshengguoji
    show_chanet_page :thank_id => 5560, :column => 'c6'
  end

  def zhuanghshow
    show_chanet_page :thank_id => 5409, :column => 'c6'
  end

  def juttuangou
    show_chanet_page :thank_id => 5632, :column => 'c6'
  end
end
