class PenNameController < ApplicationController

  before_filter :user_validate

  # Show the user pseudonym(笔名) page
  def index
    @rname = current_staff.rname
    @pen = PenName.paginate  :page => params[:page], :per_page => 20,
    :conditions=>"user_id = #{current_staff.id} and status != '-1'",
    :order=>"update_at desc"
  end

  def create_update
    addorupdate = params[:addorupdate].to_s;
    name = params[:nam]
    ischoice = params[:ischo]

    if addorupdate == "add"
      if check_name(current_staff.id, name)
        ps = PenName.find(:first, :conditions=> ["user_id = ? and name = ? and status = '-1'", current_staff.id, name])
        if ps
          ps.ischoice = ischoice
          ps.status = 1
          ps.create_at = Time.now
          ps.update_at = Time.now
          ps.update_attributes(params[:ps])
         else
          flash[:notice] = "已经有存在的笔名,请重新输入..."
         end
      else
        pen = PenName.new
        pen.user_id = current_staff.id
        pen.name = name
        pen.ischoice = ischoice
        pen.status = 1
        pen.create_at = Time.now
        pen.update_at = Time.now
        pen.save
        if pen.ischoice == 1
          cookies["penname"] = {:value => pen.name, :domain=>".51hejia.com"}
        end
      end
    else
      id = params[:p_id]
      pen = PenName.find(id)
      reviews = DecoReview.find(:all, :select => "id,c16", :conditions=> "c16 = '#{pen.name}' and formid = '77'")
      if reviews && reviews.size>0
        reviews.each do |rev|
          rev.update_attribute(:c16,name)
        end
      end
      pen.name = name
      pen.ischoice = ischoice
      pen.update_at = Time.now
      pen.update_attributes(params[:pen])
      if pen.ischoice ==1
        cookies["penname"] = {:value => pen.name, :domain=>".51hejia.com"}
      end
    end
    redirect_to :action => 'index'
  end
  #Modify the pen name is available(可用)
  #1为启用 ，0为禁用
  def edit_ischo
    pen = PenName.find(params[:id])
    pen.ischoice = params[:ischoice].to_s == '1' ? '0' : '1'
    pen.update_attributes(params[:pen])
    redirect_to :action => 'index'
  end

  #Remove pen
  #Change the value of the state pen_table be -1
  # 1为正常，-1为已经删除的
  def delete
    id = params[:id]
    @pen = PenName.find(id)
    @pen.status = -1
    @pen.update_attributes(params[:pen])
    redirect_to :action => 'index'
  end
  
  def list
    @usepen = PenName.find(:first,:conditions => ["user_id = ? and status != '1'", current_staff.id] ,:order=>"update_at desc")
    @pen = PenName.find(:all,:conditions => ["user_id = ? and status!='1'", current_staff.id] ,:order=>"ischoice desc,update_at desc")
  end

  private

  def check_name(user_id,name)
    flg = false
    pens = PenName.find(:all, :select => "name", :conditions=> user_id)
    for ps in pens
        if(name.to_s == ps.name.to_s)
            flg= true
            break
        end
    end
    return flg
  end
end
