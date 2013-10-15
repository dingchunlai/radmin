module DecorationDiariesHelper
  def options_for_score
    [["一般",0],["好",1],["差",-1]]
  end
  
  def select_for_score
    order = rand(3)
    case order
      when 0
        "#{service_select} #{construction_select} #{design_select}"
      when 1
        "#{construction_select} #{design_select} #{service_select}"
      else
        "#{design_select} #{service_select} #{construction_select}"
    end
    
  end
  
  def service_select
    content_tag("span","服务: #{select_tag "score[service_score]" , options_for_select(options_for_score)}","style"=>"border-color:#ffffff")
  end
  
  def construction_select
    content_tag("span","施工: #{select_tag "score[construction_score]" , options_for_select(options_for_score)}","style"=>"border-color:#ffffff")
  end
  
  def design_select
    content_tag("span","设计: #{select_tag "score[design_score]" , options_for_select(options_for_score)}","style"=>"border-color:#ffffff")
  end
  
end
