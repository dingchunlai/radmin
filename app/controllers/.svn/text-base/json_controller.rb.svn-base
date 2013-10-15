require 'open-uri'
require 'json'
class JsonController < ProductsController  

  def index
    @products = Product.paginate :per_page => 10, :page => params[:page], :conditions => ["source = ?", 1]
  end

  def edit
    @product = Product.find(params[:id])
    local_url = "#{RAILS_ROOT}/public/json/#{@product.category_id}/#{@product.id}.json"
    remote_url = "http://d.51hejia.com/files/hekea/jsonfiles/#{@product.category.tagid}/#{@product.id}.json"
    url = File.exist?(local_url) ? local_url : remote_url
    logger.info "==================="
    logger.info url
    #buffer = File.exist?(local_url) ? open(url).read : open(url, "UserAgent" => "Ruby-Wget").read
    begin
      buffer = open(url).read
      @result = JSON.parse(gbk_to_utf8(buffer))
      @product_params = @result['product_params']
    rescue JSON::ParserError => e
      logger.info e
    rescue Errno::EHOSTUNREACH => e
      logger.info e
    rescue
      logger.info "I don't know what's wrong!"
    end
    # convert JSON data into a hash
  end

  def update
    @product = Product.find(params[:id])
    product_params = params[:product_params]
    json_string = {}
    json_string['product_params'] = product_params
    json = json_string.to_json

    target_dir = "#{RAILS_ROOT}/public/json/#{@product.category_id}"
    if File.exist?(target_dir)
      dir = target_dir
    else
      Dir.chdir("#{RAILS_ROOT}/public/json") do
        Dir.mkdir("#{@product.category_id}")
        Dir.chdir("#{@product.category_id}")
        dir = Dir.pwd
      end
    end
    #dir = File.exist?(target_dir) ? target_dir : Dir.new(target_dir)
    File.open("#{dir}/#{@product.id}.json", "w+") do |f|
      f.puts utf8_to_gbk(json)
    end
    flash[:success] = "更新成功！"
    redirect_to edit_json_url(@product)
  end

  def show
    @product = Product.find(params[:id])
    local_url = "#{RAILS_ROOT}/public/json/#{@product.category_id}/#{@product.id}.json"
    remote_url = "http://d.51hejia.com/files/hekea/jsonfiles/#{@product.category.tagid}/#{@product.id}.json"
    url = File.exist?(local_url) ? local_url : remote_url
    #buffer = File.exist?(local_url) ? open(url).read : open(url, "UserAgent" => "Ruby-Wget").read
    buffer = open(url).read
    @result = JSON.parse(gbk_to_utf8(buffer))
    @product_params = @result['product_params']
  end

  def gbk_to_utf8(str)
    Iconv.conv("UTF-8//IGNORE", "gbk//IGNORE", str)
  end

  def utf8_to_gbk(str)
    Iconv.conv("gbk//IGNORE", "UTF-8//IGNORE", str)
  end
end
