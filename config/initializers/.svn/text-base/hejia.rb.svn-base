gem 'hejia_ext_links', '~> 0.7.12'
require 'hejia'

Hejia.configuration.set :user_model => 'hejia_user_bbs', :staff_model => 'hejia_staff', :redis => REDIS_DB, :cache => PUBLISH_CACHE
Hejia.rails_init

ActionController::Base.session_options[:memcache_server] = 'memcachehost:11211' if %w[development staging].include?(RAILS_ENV)
