class OrderMailer < ActionMailer::Base

  def sent(url)
    @subject    = url
    @body["url"]= url
#    @recipients = 'z12x21j@163.com'
    @recipients = 'luoxiaoneng@51hejia.com'
    @from       = 'service@51hejia.com'
    @sent_on    = Time.now
  end
end
