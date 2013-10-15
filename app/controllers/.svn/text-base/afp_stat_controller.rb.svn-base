class AfpStatController < ApplicationController
#  layout 'ad'

  def index
    if params[:ad_id]
      conditions = [" ad_id = ? ", params[:ad_id]]
      if params[:begintime] && params[:endtime]
        conditions[0] << " and stat_date >= ? and stat_date <= ?"
        conditions << params[:begintime]
        conditions << params[:endtime]
      end
      @afp_stats = AfpAdStat.paginate(:all, :conditions => conditions, :per_page => 20, :page => (params[:page].to_i == 0) ? 1 : params[:page].to_i )
    else
      @afp_stats = []
    end
  end

  def ad_total_hits
    if params[:ad_id]
      conditions = [" ad_id = ? ", params[:ad_id]]
      if params[:begintime] && params[:endtime]
        conditions[0] << " and stat_date >= ? and stat_date <= ?"
        conditions << params[:begintime]
        conditions << params[:endtime]
      end
      @afp_stats = AfpAdStat.find(
          :first,
          :select => "sum(hits) as total_counts",
          :conditions => conditions
      )
      render :text => @afp_stats.total_counts.to_s
    else
      render :text => "0"
    end
  end


end