class FormTokenFilter
  def self.filter(controller)
    if controller.request.post?
      token =  controller.params[:token]
      key = "#{controller.session.session_id}:form_tokens:#{token}"
      return controller.render :inline =>"alert('保存失败,可能是在同一个浏览器中同时编辑两篇文章造成的');" unless REDIS_DB.del key
    else
      token = ActiveSupport::SecureRandom.hex(32)
      key = "#{controller.session.session_id}:form_tokens:#{token}"
      REDIS_DB.setex key, 1.day, token
      controller.instance_variable_set '@token', token
   end
  end
end
