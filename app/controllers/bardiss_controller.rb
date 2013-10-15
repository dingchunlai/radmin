class BardissController < ApplicationController

  before_filter :check_cookie ,:only=>:wenda
  
  ACTIVITY_ID = Activity.find(:first, :conditions =>{:name =>'巴迪斯五一活动' }).id
  
  def index
  	@top_participants = Participant.find(:all, :limit=>30,:conditions=>[ "spent_time is not null and activity_id = ?",ACTIVITY_ID ],:order=>"spent_time")
  end

  def wenda
  	check_cookie
  	@questions = []
  	@questions = Question.find(:all,:conditions=>["category = '1' and activity_id = ?",ACTIVITY_ID] , :limit => 5, :order => 'rand()')
  	@questions.concat Question.find(:all,:conditions=>["category = '2'and activity_id = ?",ACTIVITY_ID] , :limit => 5, :order => 'rand()')
  end
  
  def timeout
  	 set_cookie
  	 redirect_to (:action => params[:retry]? "wenda" : "index")
  end
  
  def deal
  	set_cookie
	if request.post?
		@answers = Array.new
		#判断答题是否正确的逻辑是，如果提交的选项id全部都在正确选项的id集合中，并且提交数量为10,则认为是全部正确。
		params[:answer].each_pair {|key,value| @answers << value.to_i } unless params[:answer].nil?
		if @answers.uniq.size != 10
			flash[:notice] = "您只提交了#{@answers.size}道题目，答题失败。"
			redirect_to_retry_or_fail
		else
			right_options_ids = Option.find(:all ,:conditions=>{:is_currect => true}).map(&:id)
			right_answers_count =  (right_options_ids & @answers).size
			if right_answers_count == 10
				flash[:notice] = "恭喜您，回答题目完全正确。"
				session[:spent_time] = params[:spent_time]
				redirect_to :action => "success"
			else
				flash[:notice] = "很遗憾，您只回答正确了 #{right_answers_count } 道题目，再接再厉！"
				redirect_to_retry_or_fail
			end
		end
	else
		redirect_to (:action => "index")
	end
  end
  
  def retry;end

  def fail;end
  
  def wuyi;end

  def result; end
  	
  def success
  	return 	redirect_to :action=>"index" if session[:spent_time].nil?
  	@participant = Participant.new
  end
  
  def save
    return 	redirect_to :action=>"index" if session[:spent_time].nil? #防止直接进入该页面
    @participant = Participant.new(params[:participant])
	  num = Participant.count(:all,:conditions=>["idcard_id = ?" , params[:participant][:idcard_id].strip ]) 
	  if num >= 3
	    flash[:error] = "很抱歉,每人最多只能提交3次成绩,您已经提交过3次."
	    return render :action => "success"
	  end
  	@participant = Participant.new(params[:participant])
  	@participant.idcard_id = params[:participant][:idcard_id].strip
  	@participant.spent_time = session[:spent_time]
  	@participant.activity_id = ACTIVITY_ID
  	if @participant.save
  		session[:spent_time] = nil
  		redirect_to (:action => "index")
  	else
  		render :action => "success"
  	end
  end
  
 private
 
 def set_cookie
 	@tries = cookies[:badiress] || '0'
 	@tries.succ!
   cookies[:badiress] = { :value => @tries, :expires => Time.now.tomorrow.at_beginning_of_day , :doname=>'51hejia.com'}	
 end
 
 def check_cookie
  return redirect_to (:action => "fail") if cookies[:badiress] == '2'
 end
 	
 def redirect_to_retry_or_fail
 	@tries && @tries.to_i > 1 ? redirect_to (:action => "fail") : redirect_to (:action => "retry") 
 end
    

end
