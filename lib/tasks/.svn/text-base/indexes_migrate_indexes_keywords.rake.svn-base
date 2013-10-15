namespace :radmin do
  desc "begin Data migration hejia_indexes into hejia_indexes_keywords [rake radmin:indexes_migrate_indexes_keywords]"
  task :indexes_migrate_indexes_keywords => :environment  do
    migrate_array = ["巴迪斯"]
    migrate_array.each do |keyword|
      hik = HejiaIndexKeyword.find_by_name(keyword)
      unless hik.blank?
        ik_index_ids = HejiaIndexesKeyword.find(:all,:conditions => ["keyword_id = ?",hik.id]).map{|ik|ik.index_id}
        conditions = []
        conditions << "id > #{ik_index_ids.last}" unless ik_index_ids.blank?
        conditions << ["entity_type_id=1"]
        conditions << ["title like '%#{keyword}%'"]
        ids = HejiaIndex.find(:all, :conditions => conditions.join(" and ")).map{|hi|hi.id}
        ids.each do |id|
          HejiaIndexesKeyword.create(:index_id => id, :keyword_id => hik.id, :entity_type_id => 1)
        end
      end
    end
  end
  desc "end Data migration hejia_indexes into hejia_indexes_keywords [rake radmin:indexes_migrate_indexes_keywords]"
end

