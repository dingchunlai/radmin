class RuserChannelController < ApplicationController

  before_filter :user_validate, :only => [:index]

  def index
    if params[:mes]
      if params[:mes].to_s == "该用户已绑定过分类:"
        @error_nam = nil
      else
        @error_nam = params[:mes].to_s
      end
    end
    @ruser_chans = RuserChannel.find(:all, :conditions => "ruser_id=#{current_staff.id}" ,:order => "id desc")
    if @ruser_chans && @ruser_chans.size>0
      @name = Hash.new
      for rc in @ruser_chans
        #产品
        if rc.channel_type == 1
          pd = ProductCategory.find(rc.channel_id)
          @name[rc.id] = pd.name_zh
        end
        #论坛
        if rc.channel_type == 2
          af = AskForumTag.find(rc.channel_id)
          @name[rc.id] = af.name
        end
        #问吧
        if rc.channel_type == 3
          tg = WenbaTag.find(rc.channel_id)
          @name[rc.id] = tg.name
        end
      end
    end
    #product_categories table  -- model ProductCategory
    @pro_ducts = ProductCategory.first_class
    #ask_form_tags table  -- model AskForumTag
    @ask_form_tags = AskForumTag.find(:all, :select => "id,name", :conditions => "id in (472,483,484)")
    #tags table  -- model WenbaTag
    @tags = WenbaTag.find(:all, :select => "id,name", :conditions => "id in (1,38,173,265)")
    #radmin_user table  -- model  User
    @users = User.find(:all, :select => "id,rname")
  end

  def create
    message = ""
    u_id = params[:user] 
    if params[:product] && params[:product].to_i != 0
      p_id = params[:product]
      pruser = RuserChannel.find(:first, :conditions => ["ruser_id = ? and channel_id = ?",u_id,p_id])
      if pruser.nil?
        rchan = RuserChannel.new
        rchan.ruser_id = u_id
        rchan.channel_type = 1
        rchan.channel_id = p_id
        rchan.save
      else
        p_hid = params[:p_hid]
        message += "|产品--" + p_hid + "|"
      end
    end
    if params[:forum] && params[:forum].to_i != 0
      f_id = params[:forum]
      fruser = RuserChannel.find(:first, :conditions => ["ruser_id = ? and channel_id = ?",u_id,f_id])
      if fruser.nil?
        rchan1 = RuserChannel.new
        rchan1.ruser_id = u_id
        rchan1.channel_type = 2
        rchan1.channel_id = f_id
        rchan1.save
       else
         a_hid = params[:a_hid]
         message += "|论坛--" + a_hid + "|"
       end
    end
    if params[:ask] && params[:ask].to_i != 0
      a_id = params[:ask]
      aruser = RuserChannel.find(:first, :conditions => ["ruser_id = ? and channel_id = ?",u_id,a_id])
      if aruser.nil?
        rchan2 = RuserChannel.new
        rchan2.ruser_id = u_id
        rchan2.channel_type = 3
        rchan2.channel_id = a_id
        rchan2.save
      else
         t_hid = params[:t_hid]
         message += "|问吧--" + t_hid + "|"
      end
    end
    @mess = "该用户已绑定过分类:" + message
    redirect_to :action => "index", :mes => @mess
  end
  
  def delete_save
    RuserChannel.delete(params[:id].to_i)
    redirect_to :action => "index"
  end
end
