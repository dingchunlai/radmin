class ParticipantsController < ApplicationController
		helper :layout
		layout  "activity"
  def index
  	if params[:activity_id].blank?
  		@participants = Participant.all
  	else
  		if params[:order].blank?
    		@participants = Participant.find(:all,:conditions=>{:activity_id =>params[:activity_id] })
		else
			@participants = Participant.find(:all,:conditions=>{:activity_id =>params[:activity_id]},:order => params[:order ] )
		end
  	end
end

  def create
    @participant = Participant.new(params[:participant])
    if @participant.save
      flash[:notice] = "您的个人信息已提交成功"
      redirect_to @participant
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
    flash[:notice] = "删除成功."
    redirect_to request.env["HTTP_REFERER"]
  end
end
