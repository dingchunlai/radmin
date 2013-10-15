class SentMail < ActionMailer::Base

  def sent(title,content,address)
    @subject    = title
    @body       = content
    @recipients = address
    @from       = "service@51hejia.com"
    @sent_on    = Time.now
    @headers    = {}
  end
  
end
