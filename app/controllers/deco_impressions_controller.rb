class DecoImpressionsController < ApplicationController
  helper :layout
  layout 'bad_words'
  
  def index
    @firm_impressions = FirmImpression.all(FIRM_IMPRESSIONS_KEY).sort_by {rand}[0,10].join("\n")
    render :partial => "/deco_impressions/deco_firm_impressions" if params[:title] == "刷新"
  end

  def update
    if params[:deco_firm_id] && params[:deco_firm_impressions]
      if params[:deco_firm_id] == params[:deco_firm_id].to_i.to_s
        firm_id = params[:deco_firm_id]
      else
        firm_id = DecoFirm.find(:first, :conditions => ["name_zh like ?","%#{params[:deco_firm_id]}%"]).id
      end
      params[:deco_firm_impressions].split(" ").each do |impression|
        impression = DecoImpression.new :title => impression, :deco_firm_id => firm_id
        impression.save
      end
      # 增加品牌的印象的总得票数，即所有印象的得票数的总和
      DecoImpression.sum_count(params[:deco_firm_id].to_i)
      render :json => {:result => true}.to_json
    end
  end

  def edit_deco_impression
    firm_id = nil
    @firm_impressions = nil
    @deco_firm_id = nil
    if params[:firm_id]
      if params[:firm_id] == params[:firm_id].to_i.to_s
        firm_id = params[:firm_id]
      else
        firm_id = DecoFirm.find(:first, :conditions => ["name_zh like ?","%#{params[:firm_id]}%"]).id
      end
    end
    @firm_id = params[:firm_id]
    if firm_id.to_i > 0
      @deco_firm_id = firm_id
      deco_firm_impressions = $redis.zrevrange "tagged_decos:#{@deco_firm_id}:impressions", 0, - 1, :with_scores => true
      @firm_impressions = []
      0.step(deco_firm_impressions.size-1, 2) do |i|
        @firm_impressions << {:name=>deco_firm_impressions[i],:score=>deco_firm_impressions[i+1]}
      end
      render :partial => "/deco_impressions/deco_firm_impress"
    end
  end

  def destory_deco_impression
    if params[:impressions] && params[:deco_firm_id]
      params[:impressions].split(",").each do |impression|
        $redis.zrem "tagged_decos:#{params[:deco_firm_id].to_i}:impressions",impression
        DecoImpression.sum_count(params[:deco_firm_id].to_i)
      end
    end
    render :text => alert("操作已更改！") + js("history.back(-1);")
  end

  def update_firm_impression_score
    $redis.zrem "tagged_decos:#{params[:deco_firm_id].to_i}:impressions",params[:impression]
    impression = DecoImpression.new :title => params[:impression], :deco_firm_id => params[:deco_firm_id], :number => params[:score].to_i
    impression.save
    DecoImpression.sum_count(params[:deco_firm_id].to_i)
    render :text => "操作已更改！"
  end

end
