namespace :refresh do

  desc "刷新公司好评"
  task :praise2 => :environment do
     firm_ids = DecoFirm.find_by_sql(%{
  	    (select distinct deco_firm_id as firm_id from decoration_diaries where praise > 0)
        union all
        (select distinct resource_id as firm_id from remarks where praise > 0)}).map(&:firm_id).uniq

      sql = %{
        select f.id as id,avg(f.praise) as praise,avg(f.construction_praise) as construction_praise,avg(f.design_praise) as design_praise,avg(f.service_praise) as service_praise from
        ((
          select deco_firm_id as id , praise , design_praise , construction_praise, service_praise 
          from decoration_diaries where status = 1 and praise >= 0 and deco_firm_id <> "" and (is_verified = 1 or created_at <'2010-11-11' )
          )union all(
          select deco_firm_id as id , praise * 0.9 as praise , design_praise , construction_praise, service_praise 
          from decoration_diaries where status = 1 and praise >= 0 and deco_firm_id <> "" and is_verified <> 1 and created_at >= '2010-11-11'
          )union all(
            select resource_id as id , praise * 0.9 as praise, design_praise, construction_praise, service_praise
              from remarks where resource_type ='DecoFirm' and praise > 0 and resource_id <> ""
          )union all(
            select b.deco_firm_id as id , a.praise as praise , b.design_praise as design_praise ,
              b.construction_praise as construction_praise, b.service_praise as service_praise
            from remarks a inner join decoration_diaries b on a.resource_id = b.id  
            where a.resource_type ='DecorationDiary' and b.status = 1 and a.praise > 0))f
        group by id
      }
      
      @firms = DecoFirm.find_by_sql sql
  
      @firms.each do |firm|
        puts "=======>#{firm.design_praise}" if firm.id == 257565
        firm_in_database = firm.id && DecoFirm.find(:first,:conditions=>"id = #{firm.id} and is_cooperation = 1")
        unless firm_in_database.nil?
        cooperation_time = firm_in_database.cooperation_time || firm_in_database.created_at
        #综合口碑的限制期
        firm.praise = 7 if firm.praise > 7 && cooperation_time > 1.month.ago
        firm.praise = 9 if firm.praise > 9 && cooperation_time > 2.months.ago
        firm.praise = 9.4 if firm.praise > 9.4 && cooperation_time > 3.months.ago

        firm.design_praise = 7 if firm.design_praise > 7 && cooperation_time > 1.month.ago
        firm.construction_praise = 7 if firm.construction_praise > 7 && cooperation_time > 1.month.ago
        firm.service_praise = 7 if firm.service_praise > 7 && cooperation_time > 1.month.ago
        
        firm.design_praise = 9 if firm.design_praise > 9 && cooperation_time > 2.months.ago
        firm.construction_praise = 9 if firm.construction_praise > 9 && cooperation_time > 2.months.ago
        firm.service_praise = 9 if firm.service_praise > 9 && cooperation_time > 2.months.ago
        
        firm.design_praise = 9.4 if firm.design_praise > 9.4 && cooperation_time > 3.months.ago
        firm.construction_praise = 9.4 if firm.construction_praise > 9.4 && cooperation_time > 3.months.ago
        firm.service_praise = 9.4 if firm.service_praise > 9.4 && cooperation_time > 3.months.ago
        
        if firm_in_database.city == 11910
          puts "#{firm.id} => #{firm.praise}"
          firm.praise = firm.praise * 0.9
        end
        
      end
                
        update_sql = %{praise = adjusted_praise + #{firm.praise} ,   nonadjusted_praise  = #{firm.praise} ,
                      design_praise = adjusted_design_praise + #{firm.design_praise} , nonadjusted_design_praise = #{firm.design_praise} , 
                      construction_praise = adjusted_construction_praise +#{firm.construction_praise} ,nonadjusted_construction_praise = #{firm.construction_praise} ,
                       service_praise =adjusted_service_praise + #{firm.service_praise} , nonadjusted_service_praise = #{firm.service_praise}}

       DecoFirm.update_all(update_sql,:id=>firm.id)
        
        puts "#{firm.id} => praise:#{firm.praise} design_praise:#{firm.design_praise} construction_praise:#{firm.construction_praise} service_praise:#{firm.service_praise}"
      end
  end
end