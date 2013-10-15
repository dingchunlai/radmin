namespace :radmin do
  desc " send_email_on_sales "
  task :send_email_on_sales => :environment do

     firm_ids = DecoFirm.find_by_sql(%{
  	    (select distinct deco_firm_id as firm_id from decoration_diaries where praise > 0)
        union all
        (select distinct resource_id as firm_id from remarks where praise > 0)}).map(&:firm_id).uniq

      begin_at = 6.month.ago.to_date

      sql = %{
        select f.id as id, avg(f.praise) as praise,avg(f.construction_praise) as construction_praise,avg(f.design_praise) as design_praise,avg(f.service_praise) as service_praise from
        ((
          select deco_firm_id as id , praise * 0.9 as praise, design_praise , construction_praise, service_praise 
          from decoration_diaries where status = 1 and praise > 0 and deco_firm_id <> "" 
          and  created_at >= '#{begin_at}' and created_at <'2010-11-11'
          )union all(
          select deco_firm_id as id , praise * 0.8 as praise , design_praise * 0.8 as design_praise , 
          construction_praise * 0.8 as construction_praise , service_praise * 0.8 as service_praise 
          from decoration_diaries where status = 1 and praise >=0 and deco_firm_id <> "" and is_verified <> 1 and finished = 0
          and created_at >= '#{begin_at}'  and created_at >= '2010-11-11'
          )union all(
          select deco_firm_id as id , praise * 0.9 as praise , design_praise * 0.9 as design_praise , 
          construction_praise * 0.9 as construction_praise , service_praise * 0.9 as service_praise 
          from decoration_diaries where status = 1 and praise >=0 and deco_firm_id <> "" and ((is_verified <> 1 and finished = 1) or (is_verified = 1 and finished = 0))
          and created_at >= '#{begin_at}'  and created_at >= '2010-11-11'
          )union all(
          select deco_firm_id as id , praise , design_praise , construction_praise, service_praise 
          from decoration_diaries where status = 1 and praise > 0 and deco_firm_id <> "" and is_verified = 1 and finished = 1
          and created_at >= '#{begin_at}' and created_at >= '2010-11-11'
          )union all(
            select resource_id as id , praise * 0.8 as praise , design_praise * 0.8 as design_praise , 
            construction_praise * 0.8 as construction_praise , service_praise * 0.8 as service_praise
              from remarks where status = 1 and resource_type ='DecoFirm' and praise > 0 and resource_id <> "" 
          and created_at >= '#{begin_at}'  and created_at >= '2010-11-11' 
          ))f
        group by id
      }
      
    more_than_5_comments_sql = %{
       
      select deco_firm_id from(
       select resource_id as deco_firm_id, count(remarks.id) as num 
              from remarks 
              where resource_type='DecoFirm' and created_at >= '#{31.days.ago.at_beginning_of_day.to_s(:db)}' and created_at <= '#{5.days.ago.at_beginning_of_day.to_s(:db)}' and (praise > 0 or other_id is not null) 
              group by resource_id 
      )d where d.num >=5
      }
        
      
      @firms = DecoFirm.find_by_sql sql
      @more_than_5_comments = DecoFirm.find_by_sql(more_than_5_comments_sql).map(&:deco_firm_id)
    
      @firms.each do |firm|
        firm_in_database = DecoFirm.find(:first, :select => 'id, name_zh, sales_man_id', :conditions=>"id = #{firm.id} and is_cooperation = 1")
        unless firm_in_database.blank?
          unless @more_than_5_comments.include? firm_in_database.id.to_s
            # 没有帮定业务员的装修公司是不发邮件的
            sales_man = firm_in_database.sales_man
            firm_name = firm_in_database.name_zh
            unless sales_man.blank?
              puts firm_in_database.id
              mail = ["zhangnan@51hejia.com"]
              mail << sales_man.email
              title = "#{firm_name} 折分提醒"
              recipient = mail
              name = sales_man && sales_man.name || '张楠'
              context = %{#{name} 您好:
       
                  您签署负责的 #{firm_name} ，如果在接下来的一周内没有任何打分评论更新操作，预计可能将一周后分数折半，请提前提醒商家或是内部做好相关处理事宜，谢谢！
              }
              SentMail.deliver_sent(title, context, recipient)
            end
          end
        end
      end
  end
end
