require "active_support"
include ActiveSupport
require 'spreadsheet'

class BidRecordsController < ApplicationController

  ## 竞标列表页
  def index
    @bid_records = BidRecord.find(:all, :conditions => ["? < expired_time", Time.now], :order => "id desc")

  end

  ## 竞标创建页
  def new
    @bid_record = BidRecord.new(:bid_month => Time.now.month)
  end

  def create
    expired_time = (params[:expired_date] + " " + params[:info_time]).to_time
    @bid_record = BidRecord.new(params[:bid_record])
    @bid_record.expired_time = expired_time
    @brs = BidRecord.find(:all, :conditions => ["? > ? and ? < expired_time", expired_time, Time.now, expired_time])
    if @brs.blank?
      @bid_record.save
      render :action => "show", :id => @bid_record.id
    else
      flash[:error_message] = "时间段内存在有效竞标"
      render :action => "new"
    end
  end

  ## 竞标详细页
  def show
    @bid_record = BidRecord.find(params[:id])
  end

  ## 导出竞标结果页面
  def operate_export
    
  end

  ## 导出竞标结果动作
  def export_bids
    beginning_time = (Date.today.year.to_s + "-#{params[:month]}-01").to_time.at_beginning_of_month
    end_time = (Date.today.year.to_s + "-#{params[:month]}-01").to_time.months_since(1).at_beginning_of_month
    @bids = Bid.find(:all, :conditions => ["city = ? and status is null and expired_time > ? and expired_time < ?", params[:city], beginning_time, end_time])
    
    e = Excel::Workbook.new
    sheetname = "竞标结果"
    unless @bids.blank?
      array = Array.new
      @bids.each do |bid|
        item = OrderedHash.new
        item["标识"] = bid.id
        item["公司名"] = bid.deco_firm.name_zh
        item["价格"] = bid.bid_price
        item["城市"] = Tag.get_tagname_by_tagid(bid.city)
        item["失效时间"] = bid.expired_time.to_s(:db)
        item["状态"] = bid.status
        item["主题"] = bid.tag_name
        array << item
      end
      e.addWorksheetFromArrayOfHashes(sheetname, array)
      headers['Content-Type'] = "application/vnd.ms-excel;charset=GBK"
      headers['Content-Disposition'] = "attachment; filename=#{params[:month]}月竞标结果.xls"
      render :text => e.build
    else
      flash[:notice] = "没有符合条件的竞标结果！"
      render :action => "operate_export", :month => params[:month], :city => params[:city]
    end
  end

  ## 导入竞标结果页面
  def operate_inport
    
  end

  ## 导入竞标结果动作
  def inport_bids
    if params[:file].blank?
      flash[:notice] = "请输入要导入数据的文件！"
      render :action => "operate_inport"
      return false
    end
    file_name = "#{Dir.getwd}/tmp/#{params[:file].original_filename.to_s}"
    File.open(file_name,"wb") do |f|
      f.write(params[:file].read)
    end
    @oo = Spreadsheet.open(file_name)

    logger.info(@oo.worksheet(0).to_json)
    @oo.worksheet(0).each_with_index do |bid, index|
      unless index == 0
        logger.info(bid[0])
        status = bid[5].blank? ? false : true
        bid = Bid.find(bid[0].to_i)
        bid.update_attributes(:status => status)
      end

    end
    #File.delete(file_name)
    flash[:notice] = "导入完成!"
    redirect_to :action => "operate_inport"
  rescue Exception => e
    File.delete(file_name)
    flash[:notice] = e.message
    redirect_to :action => "operate_inport"
  end

end
