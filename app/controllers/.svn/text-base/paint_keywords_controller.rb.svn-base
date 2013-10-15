class PaintKeywordsController < ApplicationController
  layout "article"
  def index
    @title = "油工关键词"
    @paint_keywords = PaintKeyword.find(:all,:order => "id desc").paginate(:per_page => 20, :page => params[:page])
  end

  def new
    @title = "油工关键词"
    @paint_keyword = PaintKeyword.new()
  end

  def create
    @paint_keyword = PaintKeyword.new(params[:paint_keyword])
    if @paint_keyword.valid?
      @paint_keyword.save
      redirect_to :action => :index
    else
      flash[:error] = @paint_keyword.errors.full_messages[0]
      render :action => :new
    end
  end

  def edit
    @title = "油工关键词"
    @paint_keyword = PaintKeyword.find(params[:id])
  end

  def update
    @paint_keyword = PaintKeyword.find(params[:id])
    @paint_keyword.attributes = params[:paint_keyword]

    if @paint_keyword.valid?
      @paint_keyword.save
      redirect_to :action => :index
    else
      flash[:error] = @paint_keyword.errors.full_messages[0]
      render :action => :edit, :id => @paint_keyword.id
    end
  end

end