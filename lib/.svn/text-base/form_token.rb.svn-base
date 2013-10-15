module FormToken
  def get_form_token
     REDIS_DB.multi
     REDIS_DB.get "#{session.id}:form_token"
     REDIS_DB.del "#{session.id}:form_token"
     REDIS_DB.exec.first
   end

   def set_form_token
     token = ActiveSupport::SecureRandom.hex(32)
     REDIS_DB.setex "#{session.id}:form_token", 1.day, token
     token
   end
end
