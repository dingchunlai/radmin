namespace :import_tags_diaries do
	desc "为有标签的日记添加hejia_indexes记录"
  task :diary=>:environment  do
    diary_id = 0
    while (diaries = DecorationDiary.find(:all,:conditions => ["tags is not null and status=1 and id>#{diary_id}"], :limit => '100')).size > 0
      p "从日记ID为#{diary_id}开始tags不为空的100篇"
      diaries.each do |diary|
        p diary.id
        Decoration::MigrationDecorationDiary.run! diary.id
        diary_id = diary.id
      end
    end
  end

end



