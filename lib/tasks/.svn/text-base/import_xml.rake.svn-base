require 'nokogiri'
namespace :import do
desc "导入公司数据"
task :xml => :environment do 
  file_path = "#{RAILS_ROOT}/lib/tasks/tel2.xml"
  file = Nokogiri::XML(open(file_path))
  file.search("Row").each do |row|

    cell = row.search("Cell")
    id = cell[0].text if cell[0]
    telephone = cell[2].text if cell[2]
    detail = cell[1].text if cell[1]

    puts "id:#{id}"
    puts "detail:#{detail}"
    puts "telephone:#{telephone}"
    puts "*"*40
    firm = DecoFirm.find_by_id(id)
    next if firm.nil?
    DecoFirm.update_all("detail = '#{detail}'" ,:id => id ) if firm.detail.blank? && !detail.blank?
    DecoFirm.update_all("telephone = '#{telephone}'" ,:id => id ) if firm.telephone.blank? && !telephone.blank?
    
  end
end
end