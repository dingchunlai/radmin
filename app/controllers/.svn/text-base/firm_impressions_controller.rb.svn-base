class FirmImpressionsController < ApplicationController
  helper :layout
	layout  "bad_words"

  def index
    @key = FIRM_IMPRESSIONS_KEY
    per_page = 10
    search_word = params[:firm_impression]
    @page = params[:page] ? params[:page].to_i : 1
    if search_word.nil?
      @firm_impressions = FirmImpression.all(@key)[(@page-1)*per_page , per_page]
    else
      @firm_impressions = FirmImpression.find(@key , search_word)
    end
    @page_count = (FirmImpression.all(@key).nil? ? 1 : FirmImpression.all(@key).size) / per_page + 1
  end

  def create
    firm_impression_key = params[:key]
    params[:firm_impression].split("\r").each_with_index do |firm_impression,i|
      FirmImpression.create(firm_impression_key, firm_impression.strip)
    end
    redirect_back
  end


  def destroy
    firm_impression_key = params[:key]
    firm_impressions = params[:firm_impression]
    firm_impressions.each do |firm_impression|
      FirmImpression.destroy(firm_impression_key, firm_impression.strip)
    end
    redirect_back
  end
end
