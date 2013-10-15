desc "恢复误操作的城市"
task :recover_created_at => :environment do
  
  @decoration_diaries = DecorationDiary.find(:all,:conditions => ["created_at >= ?",14.days.ago.to_s(:db)])
  @decoration_diaries.each do |diary|
    a  = diary.created_at.to_s(:db)
    if diary.remark
   diary.update_attribute(:created_at,diary.remark.created_at) 
  else
    diary.update_attribute(:created_at,1.year.ago) 
  end
    puts "#{diary.id}:#{a} => #{diary.created_at.to_s(:db)}"
  end
end