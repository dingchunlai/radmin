class AskForumTopicPost < ActiveRecord::Base

  PER_PAGE = 10

  class << self

    #保存灌水回复
    def save_watering(topic_id, content)
      @last_watering_time = Time.now if @last_watering_time.nil? #最后灌水时间
      if @last_watering_time + 3.minutes < Time.now
        @last_watering_time = Time.now
      else
        @last_watering_time += (rand(150)+1).seconds
      end
      AskForumTopicPost.save(topic_id, HejiaUser.get_a_rand_user_id, content, '', HejiaUser.get_a_rand_ip, '', 3, @last_watering_time)
    end

    def memkey_posts_by_topic_id(topic_id, page)
      "post_posts_by_topic_id_2_#{topic_id}_#{page}"
    end

    def memkey_posts_counter(topic_id)
      "post_posts_counter_2_#{topic_id}"
    end

    #回帖统计数递增
    def post_counter_increase(topic_id)
      memkey = memkey_posts_counter(topic_id)
      count = CACHE.get(memkey).to_i
      CACHE.set(memkey, count+1)
    end

    #回帖统计数递减
    def post_counter_degression(topic_id)
      memkey = memkey_posts_counter(topic_id)
      count = CACHE.get(memkey).to_i
      CACHE.set(memkey, count-1)
    end

    #回帖统计数缓存清除
    def post_counter_cache_delete(topic_id)
      memkey = memkey_posts_counter(topic_id)
      CACHE.delete(memkey)
    end
    
    #回帖列表缓存清除
    def posts_cache_delete(topic_id, force = false)
      count = CACHE.get(memkey_posts_counter(topic_id)).to_i
      if count < PER_PAGE || force
        #只有当回复数未满一页 或 带有强制参数 的时候，才执行清除操作。
        memkey = memkey_posts_by_topic_id(topic_id, 1)
        CACHE.delete(memkey)
      end
    end


    #回帖统计数
    def posts_counter(topic_id)
      memkey = memkey_posts_counter(topic_id)
      CACHE.fetch(memkey, 3.days) do
        AskForumTopicPost.count("id", :conditions => ["forum_topic_id = ? and is_delete = 0", topic_id])
      end
    end

    #回帖列表
    def posts(topic_id, page=1)
      page = (page.to_i>0 ? page.to_i : 1)
      if page == 1
        memkey = memkey_posts_by_topic_id(topic_id, page)
        return_posts = CACHE.fetch(memkey, 3.days) do
          posts_by_topic_id(topic_id, page)
        end
        return_posts.total_entries = posts_counter(topic_id)
      else
        return_posts = posts_by_topic_id(topic_id, page)
      end
      return_posts
    end

    def posts_by_topic_id(topic_id, page=1)
      AskForumTopicPost.paginate :select => "id, user_id, egg, flower, content, created_at,ip, is_delete",
        :conditions => ["forum_topic_id = ? and is_delete = 0", topic_id],
        :order => "created_at asc",
        :total_entries => posts_counter(topic_id),
        :page => page,
        :per_page => PER_PAGE
    end


    def favor(post_id,user_id,favor_type)
      post = self.find(post_id,:select=>"id, egg, eggs, flower, flowers")
      str = post[favor_type + "s"]
      str = "" if str.nil?
      if user_id.to_i == 0
        return "只有登录用户才能执行此操作!"
      elsif str.split(" ").include?(user_id.to_s)

        return "不能重复执行此操作!"
      else
        str = " " unless pp(str)
        str += (user_id.to_s + " ")
        post[favor_type + "s"] = str
        post[favor_type] += 1
        post.save
        return post[favor_type].to_i
      end
    end

    #保存回复
    def save(forum_topic_id, user_id, content, guest_email, ip, latest_reply_userinfo, method=3, created_at=nil)

      #特殊处理：如果回帖用户是hejiabbs(即id是7326663)，则调用随机用户和随机IP
      #如果回帖用户是hejiabbs1(即id是7386409),则随机调用ip为上海的用户
      if user_id.to_i == 7326663
        user_id = HejiaUser.get_a_rand_user_id
        ip = HejiaUser.get_a_rand_ip
      elsif user_id.to_i == 7386409
        sh_user = HejiaUser.get_a_rand_user_for_shanghai
        user_id = sh_user.USERBBSID
        ip = sh_user.LOGINIP
      end

      aztp = AskForumTopicPost.new
      aztp.forum_topic_id = forum_topic_id
      aztp.user_id = user_id
      aztp.content = content
      aztp.guest_email = guest_email
      aztp.ip = ip
      aztp.method = method
      aztp.created_at = created_at.to_s(:db) if created_at
      aztp.save

      azt = AskForumTopic.find(forum_topic_id, :select=>"id,tag_id,is_top,post_counter,latest_reply_at,latest_reply_userinfo")
      azt.is_top += 1 if azt.is_top.to_i < 0  #取消沉底
      azt.post_counter = azt.post_counter + 1
      azt.latest_reply_at = Time.now
      azt.latest_reply_userinfo = latest_reply_userinfo if pp(latest_reply_userinfo)
      azt.save
      azt.tag_id
      
      AskForumTopicPost.posts_cache_delete(forum_topic_id)  #回帖列表缓存清除
      AskForumTopicPost.post_counter_increase(forum_topic_id) #回复统计数递增
      HejiaUserBbs.user_bbs_post_count(user_id, 1) if user_id.to_i > 0
      posts_step(forum_topic_id) #用户回帖执行缓存更新操作
      azt.tag_id
    end

    def delete_post(id, editor_id)
      transaction() {
        aftp = AskForumTopicPost.find(:first, :select => "id, forum_topic_id, is_delete, editor_id",
          :conditions => ["id = ?", id])
        topic_id = aftp.forum_topic_id
        aftp.editor_id = editor_id
        aftp.is_delete = 1
        aftp.save

        aft = AskForumTopic.find(:first, :select => "id, user_id, post_counter, editor_id",
          :conditions => ["id = ?", topic_id])
        aft.post_counter = aft.post_counter - 1
        aft.editor_id = editor_id
        aft.save

        AdminLog.delete_post(id, topic_id, aft.user_id, editor_id)
      }
    end

    def save_admin_edit(id, content, editor_id)
      aft = AskForumTopicPost.find(:first, :select => "id,forum_topic_id, content, editor_id",
        :conditions => ["id = ?", id])
      aft.content = content
      aft.editor_id = editor_id
      aft.save
    end

  end

end
