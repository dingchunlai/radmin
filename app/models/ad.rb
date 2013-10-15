# == Schema Information
# Schema version: 11
#
# Table name: radmin_ads
#
#  id         :integer(11)     not null, primary key
#  customer   :string(255)
#  position   :string(255)
#  pageid     :integer(11)     default(0), not null
#  pagename   :string(255)
#  starttime  :datetime
#  endtime    :datetime
#  editor     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  view_code  :string(999)
#  click_code :string(999)
#  scale      :integer(11)     default(0), not null
#

class Ad < ActiveRecord::Base

  self.table_name = "radmin_ads"

  def self.create_all_js
    0.upto(AD_SPACES.length-1) do |i|
      Ad.create_js_file(i)
    end
  end

  def self.create_js_file(pageid=0)
    pageid = pageid.to_i
    if pageid >= 0
      ads = Ad.find :all, :conditions => "endtime >= '#{Time.now.year}-#{Time.now.month}-#{Time.now.day} 00:00:00' and pageid = #{pageid}", :order => "endtime asc"
      guesswhatisthis = <<START
function guesswhatisthis(url) {
  var img = new Image(),
  cleanFn = function() { try { delete(img) } catch(e) {} };
  img.onabort = cleanFn;
  img.onerror = cleanFn;
  img.onload = cleanFn;
  img.src = url;
}
Math.rand = function(l, u)
{
     return Math.floor((Math.random() * (u-l+1))+l);
}
function get_click_url(id){
	var rand = Math.rand(1,100);
	var r = Math.rand(9999,99999);
	var n = (new Date).getTime();
	var times = 1;
	if (rand>=1&&rand<13) times = 2;
	if (rand>=13&&rand<18) times = 3;
	if (rand>=18&&rand<20) times = 4;
	return "http://afp.csbew.com/v.htm?pv=1&sp=" + id + ",0,0,1," + r + ",0,0&ex=1," + times + "," + r + ",i&ts=" + n
}
START
      str = []
      str << "var today = new Date();"
      str << "var day = today.getDate();"
      str << "var month = today.getMonth() + 1;"
      str << "var year = today.getYear();"
      str << "var date = year + '-' + month + '-' + day;"
      str << "var now = Date.parse(date.replace(/-/g, '/'));"
      for ad in ads
        render_click_url = ""
        render_click_url = "guesswhatisthis(get_click_url(#{ad.view_code.to_i}));" if ad.view_code.to_i > 0
        str << "\n"
        #str << "//#{ad.customer}_#{ad.position}"
        str << "//ID: #{ad.id} SCALE: #{ad.scale}%"
        str << "var st = Date.parse('#{ad.starttime.strftime("%Y-%m-%d")}'.replace(/-/g, '/'));"
        str << "var et = Date.parse('#{ad.endtime.strftime("%Y-%m-%d")}'.replace(/-/g, '/'));"
        str << "if (st<=now && et>=now){ if (Math.ceil(Math.random()*(100))<=#{ad.scale.to_i}){ guesswhatisthis('#{ad.click_code}'); " + render_click_url + " }}"
        #str << "if (st<=now && et>=now){ if (Math.ceil(Math.random()*(100))<=#{ad.scale.to_i}){ $.ajax({url: '#{ad.click_code}', cache: false, dataType: 'jsonp'}) }}"
        #str << "if (st<=now && et>=now){ if (Math.ceil(Math.random()*(100))<=#{ad.scale.to_i}){document.write(\"<iframe style='display:none' src='#{ad.click_code}'></iframe>\"); }}"
      end
      filepath = "#{RAILS_ROOT}/public/uploads/adc/#{AD_SPACES[pageid]}_data.js"
      file = File.new(filepath, "w")
      file.print((guesswhatisthis + str.join("\n")))
      file.close_write
    else
      fail "pageid must great than or equal to zero."
    end
  end

end
