def record_visit_test(key)
  REDIS_DB[key.to_s]
end

def getcompany(id) 
  REDIS_DB["test_analytic_zhaozhuangxiu_company_about_key_d_#{id}"]
end

def updatecompany(id, count)
  REDIS_DB["test_analytic_zhaozhuangxiu_company_about_key_d_#{id}"] = count
end

def getdianping(id)
  REDIS_DB["test_zhaozhuangxiu_key_d_#{id}"]
end

def updatedianping(id, count)
  REDIS_DB["test_zhaozhuangxiu_key_d_#{id}"] = count
end
