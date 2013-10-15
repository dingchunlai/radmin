namespace :refresh do
	desc "刷新日记和公司PV"
  task :pv=>:environment  do
    
    update_sql = "UPDATE #{DecorationDiary.table_name} SET pv = %d WHERE id = %d"
    @decoration_diaries = DecorationDiary.find(:all, :select => 'id', :conditions => "status = 1")
    num = @decoration_diaries.count
    @decoration_diaries.each_with_index do |r,i|
      pv = REDIS_DB["decoration_diaries/#{r.id}/pv"].to_i
      next if  pv == 0
      puts "#{ r.id } ==>> #{i} / #{num} ==>pv #{pv}"
      DecorationDiary.connection.execute(update_sql % [
        pv,
        r.id
      ])
    end
  
  

    update_sql = "UPDATE #{DecoFirm.table_name} SET pv_count = %d WHERE id = %d"
    @deco_firms = DecoFirm.find(:all, :select => 'id', :conditions => "state <> '-100'")
    num = @deco_firms.count
    @deco_firms.each_with_index do |f,i|
      pv = REDIS_DB["test_analytic_zhaozhuangxiu_company_about_key_d_#{f.id}"].to_i
      next if  pv == 0
      puts "#{ f.id } ==>> #{i} / #{num} ==>pv #{pv}"
      DecoFirm.connection.execute(update_sql % [
        pv,
        f.id
      ])
    end
    
end
  
end

