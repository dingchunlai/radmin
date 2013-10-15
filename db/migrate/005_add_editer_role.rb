class AddEditerRole < ActiveRecord::Migration
  def self.up
    temp = Webpm.new(:id=>998, :keyword => 'role', :value => '文章编辑', :sort => 0, :description=> '用户角色',:cdate=>Time.now,:udate=>Time.now)
    temp.save
    User.update_all "role = #{temp.id}", ["role=999"]
  end

  def self.down
    Webpm.delete_all "value='文章编辑'"
  end
end
