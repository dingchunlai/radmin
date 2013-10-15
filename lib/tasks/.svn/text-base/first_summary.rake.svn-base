namespace :first_summary do
	desc "一日汇总"
  task :firm=>:environment  do
    CITY_SUMMARY = {
      11910 => {
        'evaluation' => 0,
        'diary' => 0,
        'case' => 0,
        'comment' => 0,
        'register' => 0
      },
      12118 => {
        'evaluation' => 0,
        'diary' => 0,
        'case' => 0,
        'comment' => 0,
        'register' => 0
      },
      12117 => {
        'evaluation' => 0,
        'diary' => 0,
        'case' => 0,
        'comment' => 0,
        'register' => 0
      },
      12306 => {
        'evaluation' => 0,
        'diary' => 0,
        'case' => 0,
        'comment' => 0,
        'register' => 0
      },
      12301 => {
        'evaluation' => 0,
        'diary' => 0,
        'case' => 0,
        'comment' => 0,
        'register' => 0
      }
    }
    firm_id = 0
    while (firms = DecoFirm.find(:all,:conditions => ["state<>'-100' and state<>'-99' and id>#{firm_id}"], :limit => '50')).size > 0
      firms.each do |firm|
        #公司一日评价数
        first_evaluations = Remark.count(:conditions => ["(resource_type='DecoFirm' and resource_id=?) and created_at>=? and created_at<?", firm.id, Time.now.yesterday.beginning_of_day.to_s(:db), Time.now.beginning_of_day.to_s(:db)])
        #公司一日日记数
        first_diaries = DecorationDiary.count(:conditions => ["deco_firm_id=? and created_at>=? and created_at<?", firm.id, Time.now.yesterday.beginning_of_day.to_s(:db), Time.now.beginning_of_day.to_s(:db)])
        #公司一日案例数
        first_cases = HejiaCase.count(:conditions => ["COMPANYID=? and CREATEDATE>=? and CREATEDATE<?", firm.id, Time.now.yesterday.beginning_of_day.to_s(:db), Time.now.beginning_of_day.to_s(:db)])
        #公司一日评论数
        first_comments = 0
        first_comments += Remark.find_by_sql("SELECT count(r.id) as sum FROM decoration_diaries d, remarks r where d.deco_firm_id=#{firm.id} and d.id=r.resource_id and r.resource_type='DecorationDiary' and r.created_at>='#{Time.now.yesterday.beginning_of_day.to_s(:db)}' and r.created_at<'#{Time.now.beginning_of_day.to_s(:db)}'").map(&:sum)[0].to_i
        first_comments += Remark.find_by_sql("SELECT count(r.id) as sum FROM HEJIA_CASE d, remarks r where d.COMPANYID=#{firm.id} and d.ID=r.resource_id and r.resource_type='Case' and r.created_at>='#{Time.now.yesterday.beginning_of_day.to_s(:db)}' and r.created_at<'#{Time.now.beginning_of_day.to_s(:db)}'").map(&:sum)[0].to_i
        first_comments += Remark.find_by_sql("SELECT count(r.id) as sum FROM deco_events_firms d, remarks r where d.firm_id=#{firm.id} and d.event_id=r.resource_id and r.resource_type='DecoEvent' and r.created_at>='#{Time.now.yesterday.beginning_of_day.to_s(:db)}' and r.created_at<'#{Time.now.beginning_of_day.to_s(:db)}'").map(&:sum)[0].to_i
        #公司一日在建预约数
        first_registers = DecoRegister.find_by_sql("SELECT count(r.id) as sum FROM HEJIA_FACTORY_COMPANY d, deco_registers r where d.COMPANYID=#{firm.id} and d.ID=r.event_id and r.created_at>='#{Time.now.yesterday.beginning_of_day.to_s(:db)}' and r.created_at<'#{Time.now.beginning_of_day.to_s(:db)}'").map(&:sum)[0].to_i
        if (first_evaluations + first_diaries + first_cases + first_comments + first_registers) > 0
          company = FirmFirstSummary.new
          company.firm_id = firm.id
          company.name = firm.name_zh
          company.cooperation = firm.is_cooperation
          company.city = firm.city == 11910 ? 11910 : firm.district
          company.price = firm.price
          company.style = firm.style
          company.villa = firm.villa
          company.time = 1.days.ago.strftime("%Y-%m-%d")
          company.evaluations = first_evaluations
          company.diaries = first_diaries
          company.cases = first_cases
          company.comments = first_comments
          company.registers = first_registers
          company.save
          city = firm.city == 11910 ? 11910 : firm.district
          if CITY_SUMMARY.include?(city)
            CITY_SUMMARY[city]['evaluation'] += first_evaluations
            CITY_SUMMARY[city]['diary'] += first_diaries
            CITY_SUMMARY[city]['case'] += first_cases
            CITY_SUMMARY[city]['comment'] += first_comments
            CITY_SUMMARY[city]['register'] += first_registers
          end
        end
        firm_id = firm.id
      end
    end
    [11910,12118,12117,12306,12301].each do |city|
      area_summary = CityFirstSummary.new
      area_summary.city = city
      area_summary.time = 1.days.ago.strftime("%Y-%m-%d")
      area_summary.evaluations = CITY_SUMMARY[city]['evaluation']
      area_summary.diaries = CITY_SUMMARY[city]['diary']
      area_summary.cases = CITY_SUMMARY[city]['case']
      area_summary.comments = CITY_SUMMARY[city]['comment']
      area_summary.registers = CITY_SUMMARY[city]['register']
      area_summary.save
    end
  end
end



