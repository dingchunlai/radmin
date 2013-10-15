namespace :shanchu_firm_impression do
	desc "删除合璧设计乱码印象"
  task :impression=>:environment  do
    array = $redis.zrevrange "tagged_decos:257087:impressions", 0, - 1, :with_scores => true
    array.each do |ar|
      if ar.include?("~") || ar.include?(">") || ar.include?(",") || ar.include?("，")
        $redis.zrem "tagged_decos:257087:impressions", ar
        DecoImpression.sum_count(257087)
      end
    end
  end

end

