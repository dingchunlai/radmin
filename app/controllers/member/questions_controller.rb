class Member::QuestionsController < MemberController
  def index
    #根据日记编号或者相册图片的编号查找到对应的问答信息
    @type = params[:type].to_i
    @id = params[:id].to_i
    if params[:type].to_i == 1
      @user_note = UserNote.find(@id)
    else
      @user_photo = UserPhoto.find(@id)
      @user_note = UserNote.find(@user_photo.note_id)
    end
    @answers = UserQuestionAnswer.find(:all, :conditions => "target_type = #{@type} and target_id = #{@id} and state = 1", :order => "c_date asc")
  end
  
  
  def question_answer
    if params[:is_q_a].to_i == 1
      UserQuestionAnswer.comm_add_question_answer(request,params[:title],params[:ask_context], current_user.id, params[:target_type],params[:answertargetid],params[:is_q_a],strip(params["image"][:uploaded_data].to_s),params[:image])
    else
      u = UserQuestionAnswer.find(params[:father_id])
      UserQuestionAnswer.comm_add_question_answer(request,params[:title],params[:ask_context].gsub("回答：","").gsub("#{u.title}","").rstrip,current_user.id, params[:target_type],params[:answertargetid],params[:is_q_a],strip(params["image"][:uploaded_data].to_s),params[:image],params[:father_id])
    end
    #redirect_to :controller => "member/questions", :id => params[:answertargetid], :type => params[:target_type]
    #redirect_to :controller => "user_note_list"
    rt = alert("操作成功!")
    render :text => rt + js(top_load("/member/user_note_list"))
  end
end
