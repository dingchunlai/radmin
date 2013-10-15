namespace :add_firms_for_city do
	desc "添加新公司"
  task :add_firms => :environment  do
    tagid, district_id, city_id, city_name = 0, 0, 0, nil
    File.open('/tmp/firms.csv').each_line{ |s|
      lines = s.split('!')
      if lines[1].to_i != tagid
        tagid = lines[1].to_i
        district_id = HejiaTag.find(tagid).TAGFATHERID
        city_name = HejiaTag.find_name(district_id) #如果是直辖市的话应该用city_id
        city_id = HejiaTag.find(district_id).TAGFATHERID
      end
      unless DecoFirm.find(:first, :conditions => ["name_zh=?", lines[0]])
        firm = DecoFirm.create(:name_zh => lines[0], :name_abbr => lines[0], :business_hours => '9:00-18:00', :model => (1..5).sort_by{rand}[0], :style => (1..6).sort_by{rand}[0], :telephone => (lines[3].nil? || lines[3].empty?) ? '' : lines[3], :city => city_id, :district => district_id, :address => lines[2], :area => tagid, :state => '000', :address2 => lines[2], :price => (1..6).sort_by{rand}[0])
        p firm.name_zh
      end
    }
  end

  desc 'add new deco firms'
  task :do => :environment do
    city_tag_id = ENV['CTAG']
    firms_file = ENV['CSV']
    is_zx = ENV['ZX'] ? true : false
    abort 'please load the firms csv file' unless firms_file
    abort 'please enter the city tag_id' unless city_tag_id
    city_tag = HejiaTag.find(:first, :conditions => ["TAGID = ?" , city_tag_id])
    abort 'the city tag id is invalid' if city_tag.nil?
    firms_file_content = File.read(firms_file)
    firms = firms_file_content.split("\n")
    firms.shift
    firms.collect! { |item| item.gsub('"', '').chomp("\r") }
    # verify districts
    districts = firms.collect { |item|
      district = item.split("!")[2]
      if district.blank?
        puts item.inspect
      end
      district
    }.uniq
    districts_hash = districts.inject({}) do |hash, item|
      hash[item] = HejiaTag.find(:first, :conditions => ["TAGNAME = ? and TAGFATHERID = ?", item, city_tag.TAGID])
      hash
    end

    abort_task = false
    districts_hash.each do |key, item|
      if item.nil?
        puts "Abort: no such district[#{key}] in city #{city_tag.TAGNAME}"
        abort_task = true
      end
    end
    abort '' if abort_task

    firms.each do |item|
      name_zh, name_abbr, district_name, address, telephone = item.gsub(' ', '').split("!")
      if is_zx
        city_m = city_tag.TAGID
        district_m = districts_hash[district_name].TAGID
        area_m = 0
      else
        city_m = city_tag.TAGFATHERID
        district_m = city_tag.TAGID
        area_m = districts_hash[district_name].TAGID
      end
      unless DecoFirm.find(:first, :conditions => ["name_zh=?", name_zh])
        firm = DecoFirm.create(:name_zh => name_zh,
                               :name_abbr => name_abbr.strip,
                               :business_hours => '9:00-18:00',
                               :model => (1..5).sort_by{rand}.first,
                               :style => (1..6).sort_by{rand}.first,
                               :telephone => (telephone.nil? || telephone.empty?) ? '' : telephone,
                               :city => city_m,
                               :district => district_m,
                               :address => address, :area => area_m,
                               :state => '000', :address2 => address,
                               :price => (1..6).sort_by{rand}.first)
        puts firm.name_zh
      end
    end

  end
end

