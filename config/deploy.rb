##################################################################################
# documention: http://sites.google.com/a/51hejia.com/work/deploy_and_test
# last_modify_time: 20090526 11:25am
# author: luoxiaoneng@51hejia.com
# usage :
# 1) deploy to production environment
#	cap production deploy -S appname=the_app_you_want_release
#	cap production deploy:production:restart -S appname=the_app_u_want_resart
# 2) deploy to staging environment,staging server is server220, scheduled tasks
#     with cron for deploy ,automatic every 2 minutes!
#	cap staging deploy -S appname=the_app_you_want_release_to_staging_server
#	cap staging deploy:staging:restart -S appname=the_app_u_want_resart
# 3) deploy to localtest environment,localtest server is local server5 & server6
#	cap localtest deploy -S appname=the_app_you_want_release_to_localtest_server
#	!restart: no restart, because applications running in development environment
####################################################################################
set :application, appname

set :scm_username, "luoxiaoneng"
set :scm_password, "luoxiaoneng123"

set :use_sudo,false

set :deploy_to, "/srv/www-data/#{application}"

set :user, "deploy"  
set :scm, :subversion
set :real_revision, "HEAD"
set :deploy_via, :export

task :localtest do
	set :repository,  "svn://222.73.37.221/51hejia/Dev/Code/Ruby/#{application}"
	role :app, '192.168.0.5', '192.168.0.6'
	role :web, '192.168.0.5', '192.168.0.6'
end

task :staging do
	set :repository,  "svn://192.168.1.251/51hejia/Dev/Code/Ruby/#{application}"
	role :app, '222.73.37.220', '222.73.37.220'
	role :web, '222.73.37.220', '222.73.37.220'
	after 'deploy:restart','deploy:staging:restart'
end

task :production do
	set :repository,  "svn://192.168.1.251/51hejia/Dev/Code/Ruby/#{application}"
	    if application == "api"
	        role :app,  '124.74.201.131', '124.74.201.134'
	        role :web,  '124.74.201.131', '124.74.201.134'
		#role :app,  '222.73.37.252', '222.73.37.251'

                set :deploy_to, "/www-data/#{application}"
	    else
        	role :app, '124.74.201.135', '124.74.201.134'
	        role :web, '124.74.201.135', '124.74.201.134'
	    end
	after 'deploy:restart','deploy:production:restart'
end

namespace :deploy do
    task :restart, :roles => :app do
        #run "/root/*#{application}*.sh"
	#run "/root/test/*#{application}*.sh"
    end
end
namespace :deploy do
    namespace :production do
        task :restart, :roles => :app do
            run "/srv2009/mongrel_sh/*#{application}*.sh"
	end
    end
end

namespace :deploy do
    namespace :staging do
        task :restart, :roles => :app do
            run "/root/*#{application}*.sh"
        end
    end
end

task :after_update_code, :roles => :app do
     #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
     run "ln -nfs /srv2009/mongrel_sh/dispatch.fcgi #{release_path}/public/dispatch.fcgi"
     run "ln -nfs /srv2009/app_database_config/#{application}/database.yml #{release_path}/config/database.yml"

	if application == "radmin"
	    run "ln -nfs /srv2009/hekea/radmin/products #{release_path}/public/images/products"
	    run "ln -nfs /srv2009/hekea/radmin/vendors #{release_path}/public/images/vendors"
      run "ln -nfs /srv2009/hekea/radmin/binary #{release_path}/public/images/binary"
      run "ln -nfs /srv2009/hekea/radmin/brands #{release_path}/public/images/brands"
	    run "ln -nfs /srv2009/UserFiles #{release_path}/public/UserFiles"
      run "rm -rf #{release_path}/public/files/hekea"
            run "ln -nfs /srv2009/designer #{release_path}/public/files/designer"
            run "ln -nfs /srv2009/hekea/radmin/binary #{release_path}/public/images/binary"
            run "ln -nfs /srv2009/hekea/radmin/brands #{release_path}/public/images/brands"
	    run "rm -rf #{release_path}/public/files/hekea"
	    run "rm -rf #{release_path}/public/files/myfile"
	    run "rm -rf #{release_path}/public/files/outfile"
	    run "rm -rf #{release_path}/public/uploads"
      run "rm -rf #{release_path}/public/images/deco_booking"
            run "ln -nfs /srv2009/hekea/radmin/deco_booking #{release_path}/public/images/deco_booking"
            run "ln -nfs /srv2009/hekea #{release_path}/public/files/hekea"
	    run "ln -nfs /srv2009/designer #{release_path}/public/files/designer"
            run "ln -nfs /srv2009/hekea/radmin/myfile #{release_path}/public/files/myfile"
	    run "ln -nfs /srv2009/hekea/radmin/outfile #{release_path}/public/files/outfile"
	    run "ln -nfs /srv2009/hekea/radmin/uploads #{release_path}/public/uploads"
            run "ln -nfs /srv2009/hekea/radmin/logs #{release_path}/public/logs"
	    run "ln -nfs /srv2009/hekea/radmin/json #{release_path}/public/json"
		run "ln -nfs /srv2009/hekea/radmin/public/vendors #{release_path}/public/vendors"
            run "ln -nfs /srv2009/designer #{release_path}/public/files/designer"
	elsif application == "product"
      #run "rm #{release_path}/public/index.html"
            run "ln -nfs /srv2009/hekea/radmin/products #{release_path}/public/images/products"
            run "ln -nfs /srv2009/hekea/radmin/vendors #{release_path}/public/images/vendors"
            run "ln -nfs /srv2009/hekea/radmin/binary #{release_path}/public/images/binary"
            run "ln -nfs /srv2009/hekea/radmin/brands #{release_path}/public/images/brands"
      run "ln -nfs /srv2009/hekea/radmin/products #{release_path}/public/images/products"
      run "ln -nfs /srv2009/hekea/radmin/vendors #{release_path}/public/images/vendors"
      run "ln -nfs /srv2009/hekea/radmin/binary #{release_path}/public/images/binary"
      run "ln -nfs /srv2009/hekea/radmin/brands #{release_path}/public/images/brands"
            run "ln -nfs /srv2009/hekea/radmin/products #{release_path}/public/images/products"
            run "ln -nfs /srv2009/hekea/radmin/vendors #{release_path}/public/images/vendors"
            run "ln -nfs /srv2009/hekea/radmin/binary #{release_path}/public/images/binary"
            run "ln -nfs /srv2009/hekea/radmin/brands #{release_path}/public/images/brands"
	    run "ln -nfs /srv2009/hekea #{release_path}/public/hekea"
	    run "ln -nfs /srv2009 #{release_path}/public/files"
	    run "ln -nfs /srv2009/hekea/radmin/json #{release_path}/public/json"
	    run "ln -nfs /srv2009/UserFiles #{release_path}/public/UserFiles"
	    run "ln -nfs /srv2009/zhuanti_pages/cuxiao #{release_path}/public/cuxiao"
            run "ln -nfs /srv2009/hekea/radmin/promotion #{release_path}/public/images/promotion"
	    run "ln -nfs /srv2009/product_nfs/404.html #{release_path}/public/404.html"
	    run "ln -nfs /srv2009/product_nfs/500.html #{release_path}/public/500.html"
	    run "ln -nfs /srv2009/hekea/radmin/public/vendors #{release_path}/public/vendors"
	elsif application == "bbs"
	    run "ln -nfs /srv2009/bbs-data/uploads/ #{release_path}/public/uploads"
	elsif application == "api"
            run "rm -rf #{release_path}/public/images"
	    run "ln -nfs /srv2009/hekea/api/images #{release_path}/public/images"
	    run "rm -rf #{release_path}/public/rest"
            run "ln -nfs /srv2009/hekea/api/rest #{release_path}/public/rest"
	elsif application == "tag"
  	    #run "ln -nfs /srv2009/tag_public/article #{release_path}/public/article"
	    #run "ln -nfs /srv2009/tag_public/bbs #{release_path}/public/bbs"
	    #run "ln -nfs /srv2009/tag_public/blog #{release_path}/public/blog"
	    #run "ln -nfs /srv2009/tag_public/product #{release_path}/public/product"
	    #run "ln -nfs /srv2009/tag_public/image #{release_path}/public/image"
	    run "ln -nfs /srv2009/tag_public/all #{release_path}/public/all"
	    run "ln -nfs /srv2009/tag_public/article #{release_path}/public/article"
	    run "ln -nfs /srv2009/tag_public/bbs #{release_path}/public/bbs"
	    run "ln -nfs /srv2009/tag_public/blog #{release_path}/public/blog"
	    run "ln -nfs /srv2009/tag_public/product #{release_path}/public/product"
	    run "ln -nfs /srv2009/tag_public/image #{release_path}/public/image"
	    #run "ln -nfs /srv2009/tag_public/all #{release_path}/public/all"
  	    #run "ln -nfs /srv2009/tag_public/article #{release_path}/public/article"
	    #run "ln -nfs /srv2009/tag_public/bbs #{release_path}/public/bbs"
	    #run "ln -nfs /srv2009/tag_public/blog #{release_path}/public/blog"
	    #run "ln -nfs /srv2009/tag_public/product #{release_path}/public/product"
	    #run "ln -nfs /srv2009/tag_public/image #{release_path}/public/image"
	    run "ln -nfs /srv2009/tag_public/production_index #{release_path}/index/production"
	end
end
