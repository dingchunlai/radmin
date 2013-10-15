desc "保留最近14天统计数据"
task :clear_8_days_statistics => :environment  do
  puts "ready ..."
  @riqi = Date.today - 10
  #statistics = Statistic.find(:all, :conditions => ["created_at > ? and created_at < ?",'2012-06-28  00:00:00','2012-06-28 02:00:00'])

  statistic = Statistic.find(:first, :order => "id asc")
  date = statistic.created_at.to_date
  for i in 1...((@riqi - statistic.created_at.to_date).to_i)
    for j in 1..24
      s_time = date.to_s + ' 00:00:00'

      if j < 10
        e_time = date.to_s + " 0#{j}" + ':00:00'
      elsif j >= 10 and j != 24
        e_time = date.to_s + " #{j}" + ':00:00'
      elsif j == 24
        e_time = date.to_s + ' 23:59:59'
      end
      
      puts "开始时间：#{s_time.to_s}"
      puts "结束时间：#{e_time.to_s}"
      statistics = Statistic.find(:all,:select => "id", :conditions => ["created_at >= ? and created_at <= ?",s_time.to_time,e_time.to_time])
      puts "此次删除数量：#{statistics.count}"
      b_time = Time.now
      for statistic in statistics
        statistic.destroy
      end
      e_time = Time.now
      puts "此次删除操作用时#{e_time - b_time}秒"
      puts "删除#{date.to_s(:db)}日第#{j}个小时数据"
    end
    date += 1
  end
  puts "end ..."
end