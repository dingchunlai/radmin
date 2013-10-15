class DecoFirmsStatisticsController < ApplicationController

  layout "decocompany"

  def index
    #deco_firms_statistics?firm_id=127171&name=诗雅设计&begintime=2011-05-17&endtime=2011-05-19&city=12122&commit=Search

    if params[:commit] && params[:commit] == 'Search'
      @firms = DecoFirm.published.is_cooperation.firms_cooperation_data_statistics(params[:firm_id],params[:name],params[:city]).paginate :page => (params[:page] || 1), :per_page => 30
    else
      @firms = DecoFirm.published.is_cooperation.by_city(params[:city]).paginate :page => (params[:page] || 1), :per_page => 30
    end
  end

  def show
    @firm = DecoFirm.published.is_cooperation.find_by_id params[:id]
  end
end
