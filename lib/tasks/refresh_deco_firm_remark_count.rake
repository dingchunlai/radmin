namespace :refresh_deco_firm_remark_count do
	desc "公司留言统计"
  task :firm=>:environment  do
  firm_id = 8
    while (firms = DecoFirm.find(:all,:conditions => ["remark_only_count>0 and id>#{firm_id}"], :limit => '50')).size > 0
      p "从firm_id为#{firms.first.id}开始"
      firms.each do |firm|
        firm.remark_only_count = Remark.count(:all,:conditions=>["resource_type='DecoFirm' and resource_id=#{firm.id}"])
        firm.save
        firm_id = firm.id
      end
    end

  end
end



