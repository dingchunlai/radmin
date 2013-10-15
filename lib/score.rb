module Score
  
  # 最新的关于刷分的东西都在这里了
  def self.refresh_all_deco_firms
    deco_firms = DecoFirm.find_by_sql("select * from deco_firms where id in (select distinct deco_firm_id from decoration_diaries where deco_firm_id is not null )")
    size = deco_firms.size
    puts "About to calculate scores for decoration companies (#{size})"
    deco_firms.each_with_index do |deco_firm, index|
      index += 1
      $stderr.print(index != 1 && index % 50 == 0 ? "#{index * 100 / size}%\n" : '.')
      $stderr.flush
      refresh(deco_firm)
    end
    $stderr.puts "[Done]"
  end
	
  # 计算某一个公司的积分。
	def self.refresh(deco_firm)
    deco_firm.calculate_score
	end
	
end
