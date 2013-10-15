namespace :noncooperative_firms_impressions_import do
	desc "非合作公司印象导入"
  task :firm=>:environment  do
    firm_id = 7
    while (firms = DecoFirm.find(:all,:conditions => ["state not in ('-100','-99') and is_cooperation <>1 and id>#{firm_id}"], :limit => '100')).size > 0
      p "DecoFirm--以id为#{firm_id}开始"
      firms.each do |firm|
        $redis.del "tagged_decos:#{firm.id}:impressions"
        firm.add_deco_firm_impressions
        firm_id = firm.id
      end
    end
  end
end



