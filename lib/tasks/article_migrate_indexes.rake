namespace :radmin do
  desc "Data migration hejia_article into hejia_indexes [rake radmin:article_into_indexes ids=atricle_id]"
  task :article_into_indexes => :environment  do
    unless ENV["ids"].blank?
      # Get article_ids 
      ids = ENV["ids"].split(",").to_a
      HTTP_IMAGE = "http://image.51hejia.com".freeze
=begin
      begin
=end
        ids.each do |id|
          # Check article is not found
          article = Article.find_by_ID id
          # Article into indexes
          unless article.blank?
            unless article.KEYWORD1.nil?
              keys = article.KEYWORD1.gsub(",", ";")
              keywords = keys.split(";")
              keywords.each do |key|
                # Search keyword
                temp = HejiaIndexKeyword.find_by_name(key) || HejiaIndexKeyword.create!({:name => key})
                # create kwyword and article relations
                Relation.find(:first, :conditions => ["entity_id = ? and keyword_id = ? and relation_type = ? and from_type = ?", article.ID, temp.id, 1, 1]) || Relation.create!({:entity_id => article.ID, :relation_type => 1, :keyword_id => temp.id, :relation_type => 1, :from_type => 1}) 
              end
            end
            # Find article HEJIATAG
            tag = HejiaTag.find_by_TAGID article.FIRSTCATEGORY
            content = article.article_content.CONTENT
            # article into hejia_indexes Table
            index = HejiaIndex.find(:first, :conditions => ["entity_id = ? and entity_type_id = ? and is_valid = ?", article.id, 1, 1])
            if index.nil?
              index = HejiaIndex.new
              index.entity_id = article.ID
              index.entity_type_id = 1
              index.is_valid = 1
              index.entity_created_at = Time.now
              index.entity_updated_at = Time.now
              index.title = article.TITLE
              index.description = content
              # Need parse 
              # article.article_content
              images_content = content.scan(/\<img.*?src\=\"(.*?)\"[^>]*>/i)
              images_content && images_content.first(5).each_with_index do |image, i|
                image_url = HTTP_IMAGE.to_s + image.to_s
                case i
                when 0; index.image_url = image_url
                when 1; index.image_url2 = image_url
                when 2; index.image_url3 = image_url
                when 3; index.image_url4 = image_url
                when 4; index.image_url5 = image_url
                end
              end
              index.url = "http://www.51hejia.com/#{tag.TAGURL}/#{article.CREATETIME.strftime("%Y%m%d")}/#{article.ID}" unless tag.blank?
              index.username = article.AUTHOR
              index.entity_expired_at = "2100-01-01".to_date
              index.source = article.SOURCE
              index.resume = article.SUMMARY
              index.save
            end
          end
        end
        puts " Aready over! "
=begin
      rescue Exception
        # Note: Exceptions
        puts "Exec Errors: Sorry Load parameters failed. Plaese Check Parameters is not properly ERROR"
      end
=end
   else
      # command errors parameters errors
      puts "Plaese rake radmin:article_into_indexes ids=1,2,3,4"
    end
  end
end

