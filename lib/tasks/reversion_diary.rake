namespace :reversion_diary do
	desc "日记改版"
  task :diary=>:environment  do
    diary_id = 0
    diary_id_arry = Array.new
    while (diaries = DecorationDiary.find(:all,:conditions => ["status<>-1 and id>#{diary_id} and id not in (#{diary_id_arry.size > 0 ? diary_id_arry.join(',') : 33})"], :limit => 50, :order => "id asc")).size > 0
      p "diares以#{diary_id}开始"
      diaries.each do |diary|
        diary_post = DecorationDiaryPost.new
        diary_post.body = diary.content
        diary_post.decoration_diary_id = diary.id
        if diary_post.save
          Remark.update_all("resource_type='DecorationDiaryPost',resource_id=#{diary_post.id}","resource_type='DecorationDiary' and resource_id=#{diary.id}")
          Picture.update_all("item_type='DecorationDiaryPost',item_id=#{diary_post.id}","item_type='DecorationDiary' and item_id=#{diary.id}")
        end
        diary_id_arry << diary.id
        diary_id = diary.id
      end
    end
  end
end



