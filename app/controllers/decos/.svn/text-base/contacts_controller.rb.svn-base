class Decos::ContactsController < ApplicationController
  layout "deco"
  before_filter :find_firm
  before_filter :validate_contact, :except => [:index, :new, :create]
  
  def index
    @deco_firms_contacts = @firm.deco_firms_contacts
  end
  
  def new
    @deco_firms_contact = DecoFirmsContact.new
  end

  def create
    @deco_firms_contact = @firm.deco_firms_contacts.build(params[:deco_firms_contact])
    if @deco_firms_contact.save
      @deco_firms_contact.resolve_conflict if @deco_firms_contact.master?
      flash[:notice] = "创建成功"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def edit
    render :action => :new
  end
  
  def update
    if @deco_firms_contact.update_attributes(params[:deco_firms_contact])
      @deco_firms_contact.resolve_conflict if @deco_firms_contact.master?
      flash[:notice] = "修改成功"
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end
  
  # destroy deco_firms_contact
  def destroy
    if @deco_firms_contact.destroy
      flash[:notice] = "删除成功"
      redirect_to :action => :index
    else
      flash[:error] = "删除错误"
      redirect_to :action => :index
    end
  end

  # validate deco_firms_contact 
  private
    def validate_contact
      @deco_firms_contact = DecoFirmsContact.find_by_id params[:id]
      return head 404 if @deco_firms_contact.blank?
    end
end
