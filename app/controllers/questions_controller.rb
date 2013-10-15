class QuestionsController < ApplicationController
	before_filter :find_activity
		layout  "activity"
			helper :layout
  def index
    @questions = @activity.questions.find(:all)
  end
  
  def show
     @question = @activity.questions.find((params[:id]),:include =>:options)
     @option = @question.options.new
 #   @options = @question.options
  end
  
  def new
    @question = @activity.questions.new
  end
  
  def create
  	
    @question = @activity.questions.new(params[:question])
    @question.activity_id = @activity.id
    if @question.save
      flash[:notice] = "问题新建成功！"
      redirect_to activity_questions_path(@activity)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @question = @activity.questions.find((params[:id]))
  end
  
  def update
    @question = @activity.questions.find((params[:id]))
    if @question.update_attributes(params[:question])
      flash[:notice] = "更新成功！"
      redirect_to activity_questions_path(@activity)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:notice] = "删除问题成功."
     redirect_to activity_questions_path(@activity)
  end
  
private
	def find_activity
		@activity = Activity.find(params[:activity_id])
	end
end
