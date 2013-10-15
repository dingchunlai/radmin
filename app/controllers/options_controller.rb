class OptionsController < ApplicationController
	before_filter:find_question
			layout  "activity"
			helper :layout
	def index
		@options = @question.options
		@activity = @question.activity
		@currect_option = @options.find(:all,:conditions=>"is_currect=true")
	end
	
  def create
    @option = @question.options.new(params[:option])
    @option.question_id = @question.id
    if @option.save
      flash[:notice] = "创建成功."
      redirect_to question_options_path(@question)
    else
    	 flash[:error] ="答案选项不能为空"
      redirect_to question_options_path(@question)
    end
  end
  
  def  update
  	@option = Option.find(params[:id])
  	@question.options.each do |option|
  		option.is_currect = false
  		option.save
  	end
  	@option.is_currect = true
  	@option.save
      flash[:notice] = "设置成功."
      redirect_to question_options_path(@question)
  end
  
  def destroy
    @option = @question.options.find(params[:id])
    @option.destroy
    flash[:notice] = "删除选项成功."
    redirect_to question_options_path(@question)
  end
  
 private
 
 	def find_question
 		@question = Question.find(params[:question_id])
 	end
 	
end
