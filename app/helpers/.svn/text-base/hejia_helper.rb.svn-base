module HejiaHelper
  def get_zuyuan  #取得组员
      zuyuans = User.find :all, :select => "id, rname", :conditions => "role like '%%125%%' or role like '%%126%%'"
      h = Hash.new
      for zuyuan in zuyuans
          h[zuyuan.id] = zuyuan.rname
      end
      return h
  end
end
