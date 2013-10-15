gem 'memcache-client'
require 'memcache'

memcache_options = {
  :compression => false,
  :debug => false,
  :namespace => "radmin-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

publish_memcache_options = {
  :compression => false,
  :debug => false,
  :namespace => "publish-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

wenba_memcache_options = {
  :compression => false,
  :debug => false,
  :namespace => "wenba-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

product_memcache_options = {
  :compression => false,
  :debug => false,
  :namespace => "product-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

photo_memcache_options = {
  :compression => false,
  :debug => false,
  :namespace => "photo-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

tag_memcache_options = {
  :compression => false,
  :debug => false,
  :namespace => "tag-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}
memcache_z_options = {
  :ttl => 1,
  :compression => false,
  :debug => false,
  :namespace => "zhuangxiu-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

memcache_servers = [ 'memcachehost:11211' ]
memcache_z_servers = [ 'memcachehost:11211' ]

cache_params = *([memcache_servers, memcache_options].flatten)
publish_params = *([memcache_servers, publish_memcache_options].flatten)
wenba_params = *([memcache_servers, wenba_memcache_options].flatten)
photo_params = *([memcache_servers, photo_memcache_options].flatten)
product_cache_params = *([memcache_servers, product_memcache_options].flatten)
tag_params = *([memcache_servers, tag_memcache_options].flatten)

CACHE         = MemCache.new *cache_params
PUBLISH_CACHE = MemCache.new *publish_params
WENBA_CACHE   = MemCache.new *wenba_params
PHOTO_CACHE   = MemCache.new *photo_params
PRODUCT_CACHE = MemCache.new *product_cache_params
TAG_CACHE     = MemCache.new *tag_params
