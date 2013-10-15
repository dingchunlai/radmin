namespace :db do
  desc "为url为空hejia_indexes记录赋值开始"
  task :init_url_hejia_indexes => :environment do
    indexes = HejiaIndex.find(:all, :conditions => ["url is null and entity_type_id = ? and is_valid = ?", 1, 1])
    for index in indexes
      if index.url.blank?
        article = Article.find(index.entity_id)
        domain_prefix = if article.article_type1 && article.article_type1.TAGURL=='zhuangxiu'
          "http://d.51hejia.com/"
        elsif article.article_type1 && article.article_type1.TAGURL=='pinpaiku'
          "http://b.51hejia.com/"
        else
          "http://www.51hejia.com/"
        end
        tag_url = if article.article_type1
          article.article_type1.TAGURL + "/"
        else
          ""
        end
        url_suffix = "#{article.CREATETIME.strftime("%Y%m%d")}/#{article.ID}"
        index.url = domain_prefix + tag_url + url_suffix
        index.save
      end
    end
  end
  desc "为url为空hejia_indexes记录赋值结束"
end
