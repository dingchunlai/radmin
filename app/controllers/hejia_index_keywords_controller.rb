class HejiaIndexKeywordsController < ApplicationController
  def index
    get_conditions
    @current_page = params["current_page"].blank? ? 1 : params["current_page"]
    @per_page = params["per_page"].blank? ? 100 : params["per_page"]

    @hejia_indexes = HejiaIndexKeyword.paginate(:select => "i.id,i.title,i.url,k.id as k_id,k.name,k.created_at",
      :joins => "k, 51hejia_index.hejia_indexes_keywords hisk,51hejia_index.hejia_indexes i",
      :conditions => @conditions + " and hisk.index_id = i.id",
      :order => "hisk.keyword_id asc,hisk.index_id asc",
      :total_entries => HejiaIndexKeyword.count(:joins => "k, 51hejia_index.hejia_indexes_keywords hisk", :conditions => @conditions),
      :page => @current_page.to_i,
      :per_page => @per_page)
  end

  ## 将hejia_indexes导出为Excel表格存储的数据
  def export_hejia_indexes
    get_conditions
    @current_page = params["current_page"].blank? ? 1 : params["current_page"]
    @per_page = params["per_page"].blank? ? 100 : params["per_page"]

    @hejia_indexes = HejiaIndexKeyword.paginate(:select => "i.id,i.title,i.url,k.id as k_id,k.name,k.created_at",
      :joins => "k, 51hejia_index.hejia_indexes_keywords hisk,51hejia_index.hejia_indexes i",
      :conditions => @conditions + " and hisk.index_id = i.id",
      :order => "hisk.keyword_id asc,hisk.index_id asc",
      :total_entries => HejiaIndexKeyword.count(:joins => "k, 51hejia_index.hejia_indexes_keywords hisk", :conditions => @conditions),
      :page => @current_page.to_i,
      :per_page => @per_page)

    e = Excel::Workbook.new
    sheetname = "标签标记列表"
    unless @hejia_indexes
      flash[:notice] = "没有符合条件的用户！"
      redirect_to "/common/export"
    else
      array = Array.new
      @hejia_indexes.each do |hejia_index|
        item = Hash.new
        item["编号"] = hejia_index.k_id
        item["名称"] = hejia_index.name
        item["创建日期"] = hejia_index.created_at.strftime("%Y-%m-%d")
        item["对象编号"] = hejia_index.id
        item["标题"] = hejia_index.title
        item["网址"] = hejia_index.url
        array << item
      end
      e.addWorksheetFromArrayOfHashes(sheetname, array)
      headers['Content-Type'] = "application/vnd.ms-excel;charset=UTF-8"
      headers['Content-Disposition'] = "attachment; filename=标签标记列表.xls"
      headers['Cache-Control'] = ''
      render :text => e.build
    end
  end

  private
  def get_conditions
    return false unless pvalidate("管理员")
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @conditions = "true"
    @conditions += " and k.created_at <= '#{@riqi2} 23:59:59'" if pp(@riqi2)
    @conditions += " and k.created_at >= '#{@riqi1} 0:0:0'" if pp(@riqi1)
    @conditions += " and k.id = hisk.keyword_id"
  end

end
