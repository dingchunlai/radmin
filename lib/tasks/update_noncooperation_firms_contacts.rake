namespace :update_nocooperation_firms_contacts do
	desc "修改非合作公司电话与contracts"
  task :update_contact => :environment  do
    p "修改非合作公司电话与contracts"
    telephones = {
      12118 => '0510-82700070',
      12306 => '0571-88831082',
      12301 => '0574-27673566',
      12117 => '0512-68703960',
      11910 => '62676666-8030，62676666-8047'
    }
    qq = {
      12118 => 'QQ:62751543',
      12306 => 'QQ:1025439731',
      12301 => 'QQ:27327132',
      12117 => 'QQ:1466079700',
      11910 => 'QQ:471953858，1293214783'
    }
    firm_id = 7
    while (firms = DecoFirm.find(:all,:conditions => ["(city=11910 or district in (12306,12301,12118,12117)) and state<>'-100' and state<>'-99' and is_cooperation<>1 and id>#{firm_id}"], :limit => '50')).size > 0
      p "以firm_id为#{firm_id}每50一组开始"
      firms.each do |firm|
        city_id = firm.city == 11910 ? 11910 : firm.district
        firm.update_attribute(:telephone, telephones[city_id]) unless firm.telephone == telephones[city_id]
        contracts = DecoFirmsContact.find(:all, :conditions => "deco_firm_id=#{firm.id}")
        if contracts.size > 0
          p "修改_firm_id#{firm.id}的_contract"
          contracts.each do |contract|
            contract.update_attributes(:address => firm.address2, :telephone => firm.telephone, :online_contact => qq[city_id])
          end
        else
          p "新建_firm_id#{firm.id}的_contract"
          contract = DecoFirmsContact.create(:address => firm.address2, :is_master => 1, :telephone => firm.telephone, :online_contact => qq[city_id], :deco_firm_id => firm.id)
        end
        firm_id = firm.id
      end
    end
  end
end

