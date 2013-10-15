class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article  # This sweeper is going to keep an eye on the Article model 


  def after_create(record)
    # expire_cache_for(record)
  end

   # If our sweeper detects that a Article was updated call this 
  def after_update(record)
    expire_cache_for(record)
  end


  def after_destory(record)
    # expire_cache_for(record)
  end

  private
  def expire_cache_for(record)

    if record.is_a? Article
      PUBLISH_CACHE.delete("key_publish_article_show_content_20090512_#{record.ID}")
      # just for test severial days 2009-06-26 15:59:50
      if  PUBLISH_CACHE.get("key_publish_article_show_content_20090512_#{record.ID}").blank?
        p "=========just test  several days==========="
        p %|article id #{record.ID} deleted ok #{Time.now.strftime("%Y/%m/%d %H:%M:%S")}|
        p "==========================================="
      end
    end



    # CACHE.delete("key_publish_tag_#{@tag_id}_article_list_results_page_#{@page}_#{@format}")
  end


end
