AREAS = "其它,黄浦区,卢湾区,徐汇区,长宁区,静安区,普陀区,闸北区,虹口区,杨浦区,闵行区,宝山区,嘉定区,浦东新区,金山区,松江区,青浦区,南汇区,奉贤区,崇明县,北京,天津,重庆,广州,沈阳,武汉,郑州,杭州,南京,福州,长沙,济南,成都,深圳,青岛,大连,厦门,苏州,温州,宁波"
DECO_DESFEE = "----,免费,20-50,50-80,80-120,120-200,200以上".split(",")
DECO_DESAGE = "----,1年,2-3年,3-5年,5-8年,8年以上".split(",")
DECO_DESSTYLE = "----,现代简约,田园风格,欧美式,中式风格,地中海,混搭,其它".split(",")

WEBSITE_NAME = "和家网后台管理"
WEBSITE_DOMAIN = "radmin.hejia.com"
WEBPM_SORT = ["基本参数","其他参数"]
SHOW_ERROR = true #决定get_error方法是否显示详细错误
FORM_STATE = "隐藏,正常".split(",")  #表单状态分类
FORM_DATA_STATE = "待处理,已处理".split(",") #表单数据状态分类
FORM_CTYPE = "字符串,单项选择,多项选择,下拉菜单,长文本,文件上传" #表单字段分类
HEJIA_STATE = "待处理,已处理,已发送,已作废,已成交,已放弃,已分配".split(",") #核价单状态分类
DINGDAN_STATE = "核价中,待预约,已预约,已成交,已作废".split(",")  #订单状态分类
VENDOR_STATE = "停用,已审核,未审核,作废".split(",")  #商铺状态分类
COMMENT_SORT1 = ["设计师评分", "设计能力", "预算报价合理性", "施工质量", "售后服务"] #评论分类01评分项
COMMENT_SORT2 = [] #评论分类02评分项
COMMENT_SORT3 = [] #评论分类03评分项 供“单图专区”使用
BBS_ADMIN_OPERATION = ["删除主帖","删除回帖","封ID","主置顶","置顶","取消主置顶","取消置顶","标题标色","标题跟NEW","帖子转移"]
PINLEI_SORT = ["请选择","涂料","地板","瓷砖","卫浴","家具","布艺","家电","橱柜","采暖","照明","水处理"]  #品类频道大类分类
ZHUANQU_BOARD = ["", "装修", "装饰", "产品", "行业", "品牌", "城市", "家居生活"]
ZHUANQU_BOARD_SPELL = ["", "d", "deco", "prod", "news", "b", "d", "case"]

if RAILS_ENV == "development"
  TAG_HOST_NAME = "localhost:3001"
else
  TAG_HOST_NAME = "tag.51hejia.com"
end

IMAGE_UPLOAD_PREFIX_PATH = ""
PRODUCT_DEFAULT_PRIMARY_IMAGE_PATH = "/images/product.jpg"
PRODUCT_IMAGES_PATH_PREFIX = "http://d.51hejia.com/files/hekea/img/"
MARKET_DEFAULT_LOGO_PATH = "/images/market_logo.jpg"
MARKET_LOGO_PATH_PREFIX = "http://d.51hejia.com/files/hekea/market/"
VENDOR_DEFAULT_LOGO_PATH = "/images/vendor_logo.jpg"
VENDOR_LOGO_PATH_PREFIX = "http://d.51hejia.com/files/companylogo/"
BRAND_DEFAULT_LOGO_PATH = "/images/brand_logo.jpg"
BRAND_LOGO_PATH_PREFIX = "http://d.51hejia.com/files/companylogo/"
COMPANY_FORMID="60"
TIMESTAMP = Time.now.to_i.to_s
PINGLUN_ID=77
BRANDS_ID = "987,151,143,154,150,439,703,650,222,156,836,1543,1222,2212,627,585,78,592,373,149,1096,1475,2214,1820,304,1794,327,170,1795,1305,2078,2210,391,178,255,1084,1222,156,148,1984"

ARTICLE_ADD_EVENT_ID=1
ARTICLE_ADD_ENTITY_TYPE=1

AD_SPACES = ["www", "tuku", "bbs"]

# 不和谐词汇在redis中的key
BAD_WORDS_KEY = "bad_words"
DECO_CASE_NAME_BAD_WORDS_KEY = "deco_case_name_bad_words"
FIRM_IMPRESSIONS_KEY = "firm_impressions"

TIME_IN_SECONDS = Time.now.to_i.to_s