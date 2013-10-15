# == Schema Information
#
# Table name: user_question_answers
#
#  id          :integer(11)     not null, primary key
#  target_type :integer(11)     not null
#  target_id   :integer(11)     not null
#  is_q_a      :integer(11)     not null
#  father_id   :integer(11)
#  uname       :string(255)
#  remote_ip   :string(255)
#  user_id     :integer(11)
#  c_date      :datetime
#  u_date      :datetime
#  context     :text
#  state       :integer(11)     not null
#  image_url   :string(225)
#  is_expert   :integer(11)
#  title       :string(225)
#

class UserQuestionAnswer < ActiveRecord::Base
    self.table_name="user_question_answers"
    self.primary_key = "id"
    #target_type  1日记   2相册
    #is_q_a       1问     2答
    #state        1存在   2删除
    #is_expert    1专家   2非专家
    
    
    def self.comm_add_question_answer(request,title,context,ind_id,type,targetid,is_q_a,image_date,iamge_url,father_id=nil)
      question = UserQuestionAnswer.new
      question.context = context.to_s
      question.remote_ip = request.remote_ip.to_s
      if ind_id
        question.user_id = ind_id.to_i
        bbs = HejiaUserBbs.find(:first, :select => "USERNAME,USERTYPE", :conditions => "USERBBSID = #{ind_id.to_i}")
        question.uname = bbs.USERNAME
        if bbs.USERTYPE.to_i == 100
          question.is_expert = 1
        else
          question.is_expert = 2
        end
      else
        question.uname = "匿名"
      end
      if title
        question.title = title
      end
      if image_date != ""
        image = ArticleImage.new(iamge_url)
        image.save
        question.image_url = "/files/hekea/article_img/sourceImage/"+Time.now.strftime("%Y%m%d").to_s+"/"+image.filename
      end
      
      question.target_type = type.to_i
      question.target_id = targetid.to_i
      if father_id
        question.father_id = father_id.to_i
      end
      question.is_q_a = is_q_a
      question.c_date = Time.now
      question.u_date = Time.now
      question.state = 1
      question.save
    end
    
    def self.get_question(id)
      result = UserQuestionAnswer.find(:all,:conditions => "target_type=2 and target_id=#{id} and is_q_a=1 and state=1")
      return result
    end
    
    def self.get_answer(aid)
      result = UserQuestionAnswer.find(:all,:conditions => "target_type=2 and is_q_a=2 and father_id=#{aid} and state=1")
      return result
    end
end
