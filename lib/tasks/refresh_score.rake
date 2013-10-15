namespace :recal do
	desc "重新计算所有公司的积分"
  task :score => [:partners, :nonpartners]

  namespace :score do
    desc "重新计算所有合作公司的分数."
    task :partners => :environment do
      t = Time.now
      puts "Resetting scores."
      DecoFirm.update_all(
        'design_score = 0,       design_score_new = 0,' +
        'construction_score = 0, construction_score_new = 0,' +
        'service_score = 0,      service_score_new = 0,' +
        'budget_score = 0,       budget_score_new = 0,' +
        'total_score = 0,        total_score_new = 0 ',
        "is_cooperation = 1"
      )
      puts "Cost: #{Time.now - t}sec."
                            
      t = Time.now
      puts "Calculating old scores."
      companies = DecoFirm.find_by_sql("select * from deco_firms where id in (select distinct deco_firm_id from decoration_diaries where deco_firm_id is not null ) AND is_cooperation = 1")
      num = companies.size
      companies.each_with_index do |company,i|
        puts  "#{company.id} == #{i} / #{num}"
        DecoReview.cal_commonts_by_companyid2(company.id, true)
      end

      DecoFirm.update_all(
        "design_score = design_score_new , construction_score = construction_score_new , budget_score = budget_score_new , service_score = service_score_new ,total_score = total_score_new",
        "is_cooperation = 1"
      )
      puts "Cost: #{Time.now - t}sec."
      
      t = Time.now
      puts "Calculating new scores."
      DecoFirm.find_by_sql(
        "select * from deco_firms where id in (select distinct deco_firm_id from decoration_diaries where deco_firm_id is not null) AND is_cooperation = 1"
      ).each do |deco_firm|
        puts "[REFRESH] #{deco_firm.id}"
        Score.refresh(deco_firm)
      end
      puts "Cost: #{Time.now - t}sec."
    end

    desc "重新计算所有非合作公司的分数."
    task :nonpartners => :environment do
      t = Time.now
      puts "Resetting scores."
      DecoFirm.update_all(
        'design_score = 0,       design_score_new = 0,' +
        'construction_score = 0, construction_score_new = 0,' +
        'service_score = 0,      service_score_new = 0,' +
        'budget_score = 0,       budget_score_new = 0,' +
        'total_score = 0,        total_score_new = 0 ',
        "is_cooperation <> 1"
      )
      puts "Cost: #{Time.now - t}sec."
                            
      t = Time.now
      puts "Calculating old scores."
      companies = DecoFirm.find_by_sql("select * from deco_firms where id in (select distinct deco_firm_id from decoration_diaries where deco_firm_id is not null ) AND is_cooperation <> 1")
      num = companies.size
      companies.each_with_index do |company,i|
        puts  "#{company.id} == #{i} / #{num}"
        DecoReview.cal_commonts_by_companyid2(company.id, true)
      end

      DecoFirm.update_all(
        "design_score = design_score_new , construction_score = construction_score_new , budget_score = budget_score_new , service_score = service_score_new ,total_score = total_score_new",
        "is_cooperation <> 1"
      )
      puts "Cost: #{Time.now - t}sec."
      
      t = Time.now
      puts "Calculating new scores."
      DecoFirm.find_by_sql(
        "select * from deco_firms where id in (select distinct deco_firm_id from decoration_diaries where deco_firm_id is not null) AND is_cooperation <> 1"
      ).each do |deco_firm|
        puts "[REFRESH] #{deco_firm.id}"
        Score.refresh(deco_firm)
      end
      puts "Cost: #{Time.now - t}sec."
    end
  end
end

namespace :refresh do
  desc "刷新公司积分"
  task :score => :environment do
    Score.refresh_all_deco_firms
  end
end
