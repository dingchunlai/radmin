namespace :refresh do

  
  desc "初始化好评度"
  task :init_praise => :environment do
    STAR = {
      227745=>6,
      255659=>6,
      140929=>6,
      256094=>6,
      141330=>6,
      256531=>6,
      256140=>6,
      255649=>6,
      256482=>5,
      252280=>5,
      256432=>5,
      247465=>5,
      255669=>5,
      140096=>5,
      140377=>5,
      256153=>4,
      255824=>4,
      256254=>4,
      256367=>4,
      256272=>4,
      256283=>4,
      256285=>4,
      256292=>4,
      256227=>4,
      256210=>4,
      256170=>4,
      255826=>4,
      255828=>4,
      256152=>4,
      255853=>4,
      256075=>4,
      256088=>4,
      256137=>4,
      256295=>4,
      256503=>4,
      256510=>4,
      256516=>4,
      256523=>4,
      256551=>4,
      256552=>4,
      256553=>4,
      256569=>4,
      256630=>4,
      256635=>4,
      256500=>4,
      256497=>4,
      256478=>4,
      256303=>4,
      256327=>4,
      256346=>4,
      256395=>4,
      256404=>4,
      256428=>4,
      256433=>4,
      256445=>4,
      256451=>4,
      256462=>4,
      256644=>4,
      255787=>4,
      229520=>4,
      252283=>4,
      191979=>4,
      197425=>4,
      197220=>4,
      196225=>4,
      196167=>4,
      246205=>4,
      191704=>4,
      252284=>4,
      252287=>4,
      141165=>4,
      255714=>4,
      255688=>4,
      255710=>4,
      196387=>4,
      196338=>4,
      196279=>3,
      256507=>3,
      256495=>3,
      256348=>3,
      256476=>3,
      256414=>3,
      256442=>3,
      256441=>3,
      256431=>3,
      196322=>3,
      256508=>3,
      141097=>3,
      257069=>3,
      257067=>3,
      256676=>3,
      256650=>3,
      256641=>3,
      256613=>3,
      256612=>3,
      256611=>3,
      256609=>3,
      256593=>3,
      256575=>3,
      140461=>3,
      257072=>3,
      256547=>3,
      140981=>3,
      256525=>3,
      257070=>3,
      256335=>3,
      256107=>3,
      256302=>3,
      255821=>3,
      256296=>3,
      199527=>3,
      256165=>3,
      256290=>3,
      256173=>3,
      256239=>3,
      256279=>3,
      256312=>3,
      256095=>3,
      256317=>3,
      252292=>3,
      256270=>3,
      256352=>3,
      256350=>3,
      244265=>3,
      256330=>3,
      256660=>2,
      140290=>2,
      140077=>2,
      257019=>2,
      657=>2,
      256657=>2,
      255690=>2,
      256412=>2,
      243245=>2,
      256528=>2,
      256475=>2,
      256429=>2,
      256396=>2,
      141049=>2,
      256477=>2,
      257059=>1,
      255763=>1,
      252289=>1,
      197262=>1,
      196246=>1,
      256654=>1,
      257071=>1,
      112232=>1,
      197508=>1,
      256637=>1,
      140964=>1,
      256252=>1,
      140455=>1,
      230440=>1,
      252185=>1,
      256596=>1,
      252274=>1,
      252268=>1,
      229245=>1,
      196022=>1,
      196031=>1,
      197802=>1,
      140778=>1,
    }
    puts "归零"
    DecoFirm.update_all("praise = 0,design_praise=0,construction_praise=0,service_praise=0,nonadjusted_praise=0,adjusted_praise=0,nonadjusted_design_praise=0,adjusted_design_praise=0,nonadjusted_construction_praise=0,adjusted_construction_praise=0,nonadjusted_service_praise=0,adjusted_service_praise=0" )
    Remark.update_all("praise = 0,design_praise=0,construction_praise=0,service_praise=0")
    DecorationDiary.update_all("praise = null,design_praise = null,construction_praise = null,service_praise=null" )
    DecoFirm.update_all("created_at = '2009-1-1'","created_at is null")
    DecoFirm.update_all("star = 0" ,:star => nil )
    
    puts "恢复上海地区分数到8月10日"
   @deco_firms = DecoFirm.find(:all,:conditions=>"city = 11910 and star > 0")
   @deco_firms.each do |firm|
    firm.update_attribute(:star,STAR[firm.id]) if STAR[firm.id]
    puts "#{firm.id} => #{STAR[firm.id]}" if STAR[firm.id]
   end
    
    puts "把公司分数分配到日记"
    update_sql = %{ update decoration_diaries, 
      (select a.id as id,b.star + 3 as praise from decoration_diaries a inner join deco_firms b on a.deco_firm_id = b.id 
      where a.status = 1 and b.star > 0)c
      set decoration_diaries.praise = c.praise where decoration_diaries.id = c.id }
    DecorationDiary.connection.execute(update_sql)
    
    puts "把公司分数分配到各个子项目"
    DecorationDiary.update_all("design_praise = praise, construction_praise=praise, service_praise = praise")
  end
  
  desc "初始化详细"
  task :init_detail_praise => :environment do
   # DecorationDiary.update_all(" design_praise = 0,construction_praise= 0,service_praise = 0","created_at <= '2010-8-15'")
    
    ["design","construction","service"].each do |praise|
      score = 9.5
     @shanghai_firms = DecoFirm.find(:all,:conditions =>"city = 11910 and is_cooperation = 1 and #{praise}_score_new > 0",:order =>"#{praise}_score_new desc")
     @shanghai_firms.each do |firm|
      DecorationDiary.update_all("#{praise}_praise = #{score}","deco_firm_id = #{firm.id} and created_at <= '2010-8-15'")
      puts "#{praise}: #{firm.id} => #{score}"
      score -= 0.1
     end
    end
    
    [12117,12301,12306,12118].each do |district|
    ["design","construction","service"].each do |praise|
      score = 9.5
     @shanghai_firms = DecoFirm.find(:all,:conditions =>"district = #{district} and is_cooperation = 1 and #{praise}_score_new > 0",:order =>"#{praise}_score_new desc")
     @shanghai_firms.each do |firm|
      DecorationDiary.update_all("#{praise}_praise = #{score}","deco_firm_id = #{firm.id} and created_at <= '2010-8-15'")
      puts "#{district}:#{praise}: #{firm.id} => #{score}"
      score -= 0.1
     end
    end
    end
  end
  
  desc "刷新公司好评"
  task :praise => :environment do
     firm_ids = DecoFirm.find_by_sql(%{
  	    (select distinct deco_firm_id as firm_id from decoration_diaries where praise > 0)
        union all
        (select distinct resource_id as firm_id from remarks where praise > 0)}).map(&:firm_id).uniq

      sql = %{
        select f.id as id,avg(f.praise) as praise,avg(f.construction_praise) as construction_praise,avg(f.design_praise) as design_praise,avg(f.service_praise) as service_praise from
        ((select deco_firm_id as id , praise , design_praise , construction_praise, service_praise from decoration_diaries where status = 1 and praise >= 0 and deco_firm_id <> "") 
            union all
            (select resource_id as id , praise , design_praise , construction_praise, service_praise  from remarks where resource_type ='DecoFirm' and praise > 0 and resource_id <> "")
            union all
            (select b.deco_firm_id as id , a.praise as praise , b.design_praise as design_praise ,
             b.construction_praise as construction_praise, b.service_praise as service_praise
            from remarks a inner join decoration_diaries b on a.resource_id = b.id  
            where a.resource_type ='DecorationDiary' and b.status = 1 and a.praise > 0))f
        group by id
      }
      
      more_than_10_comments_sql = %{
        select d.deco_firm_id from (select c.deco_firm_id, sum(c.num) as num from
          ((select deco_firm_id,sum(b.num) as num from decoration_diaries a 
          inner join(select resource_id as decoration_dairy_id , count(*) as num 
          from remarks 
          where is_replied = 0 and resource_type="DecorationDiary"  and created_at >= '#{1.month.ago.to_s(:db)}' 
          group by resource_id)b 
        on a.id = b.decoration_dairy_id
        group by deco_firm_id)
      union all
      (select resource_id as deco_firm_id , count(*) as num 
      from remarks
      where is_replied = 0 and resource_type='DecoFirm'  and created_at >= '#{1.month.ago.to_s(:db)}' group by resource_id))c
      group by c.deco_firm_id)d where d.num >= 10
      }
      
    #  @more_than_10_comments = DecoFirm.find_by_sql(more_than_10_comments_sql).map(&:deco_firm_id)
     # p @more_than_10_comments
      @firms = DecoFirm.find_by_sql sql
  
      @firms.each do |firm|
        
        firm_in_database = firm.id && DecoFirm.find(:first,:conditions=>"id = #{firm.id} and is_cooperation = 1")
        unless firm_in_database.nil?
        cooperation_time = firm_in_database.cooperation_time || firm_in_database.created_at
        #综合口碑的限制期
        firm.praise = 7 if firm.praise > 7 && cooperation_time > 1.month.ago
        firm.praise = 9 if firm.praise > 9 && cooperation_time > 2.months.ago
        firm.praise = 9.4 if firm.praise > 9.4 && cooperation_time > 3.months.ago

        firm.design_praise = 5 if firm.design_praise > 5 && cooperation_time > 1.month.ago
        firm.construction_praise = 5 if firm.construction_praise > 5 && cooperation_time > 1.month.ago
        firm.service_praise = 5 if firm.service_praise > 5 && cooperation_time > 1.month.ago
        
        firm.design_praise = 9 if firm.design_praise > 9 && cooperation_time > 2.months.ago
        firm.construction_praise = 9 if firm.construction_praise > 9 && cooperation_time > 2.months.ago
        firm.service_praise = 9 if firm.service_praise > 9 && cooperation_time > 2.months.ago
        
        firm.design_praise = 9.4 if firm.design_praise > 9.4 && cooperation_time > 3.months.ago
        firm.construction_praise = 9.4 if firm.construction_praise > 9.4 && cooperation_time > 3.months.ago
        firm.service_praise = 9.4 if firm.service_praise > 9.4 && cooperation_time > 3.months.ago
        
        if firm_in_database.city == 11910
          firm.praise = firm.praise * 0.9
          firm.design_praise = firm.design_praise * 0.9
          firm.construction_praise = firm.construction_praise * 0.9
          firm.service_praise = firm.service_praise * 0.9
        end
        
      end
                
        
        # 最近30天低于10个评价,则分数减半
       # firm.praise = firm.praise / 2 if !@more_than_10_comments.include? firm.id.to_s
       # puts "#{firm.id} :#{!@more_than_10_comments.include? firm.id.to_s} #{firm.id.class} #{@less_than_10_comments.class}"

        update_sql = %{praise = adjusted_praise + #{firm.praise} ,   nonadjusted_praise  = #{firm.praise} ,
                      design_praise = adjusted_design_praise + #{firm.design_praise} , nonadjusted_design_praise = #{firm.design_praise} , 
                      construction_praise = adjusted_construction_praise +#{firm.construction_praise} ,nonadjusted_construction_praise = #{firm.construction_praise} ,
                       service_praise =adjusted_service_praise + #{firm.service_praise} , nonadjusted_service_praise = #{firm.service_praise}}

        DecoFirm.update_all(update_sql,:id=>firm.id)
        puts "#{firm.id} => praise:#{firm.praise} design_praise:#{firm.design_praise} construction_praise:#{firm.construction_praise} service_praise:#{firm.service_praise}"
      end
      
  end
  
  
end

def protected_score score
  
  case 
    when  (0..100) === score ; [0,5]
    when  (100..200) === score ; [0.5,5]
    when  (200..300) === score ; [1.5,5]
    when  (300..400) === score ; [2.5,5]
    when  (400..500) === score ; [3.5,5]
    when  (500..600) === score ; [4.5,6]
    when  (600..700) === score ; [5.5,7]
    when  (700..800) === score ; [6.5,8]
    when  (800..900) === score ; [7.5,9]
    when  (900..1000) === score ; [8.5,10]
    else ; [9,10]
  end
end

def protected_praise detail_praise , score
  praise_range = protected_score(score.to_i).to_a
  if detail_praise < praise_range[0]
    praise_range[0]
  elsif detail_praise > praise_range[1]
    praise_range[0]
  else
    detail_praise
  end
end