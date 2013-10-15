# -*- coding: utf-8 -*-
class Adddecoform < ActiveRecord::Migration
  def self.up
    create_table :booking_decos do |t|
      t.column :name, :string   # 姓名
      t.column :address, :string # 地址
      t.column :zip_code, :string # 邮政编码
      t.column :location, :integer # 待装修区域
      t.column :xiaoqu_name, :integer # 待装修小区名称

      t.column :tel, :string    # 联系电话

      t.column :email, :string  # email
      t.column :preview_time, :datetime # 预计装修时间

      t.column :city_id, :string     # 城市
      t.column :region_id, :string     # 区域

      t.column :fang, :string     # 房形 房
      t.column :ting, :string     # 房形 厅
      t.column :wei, :string     # 房形 卫

      t.column :building_area, :integer # 建筑面积
      t.column :house_photo_path, :string    # 房形图
      t.column :deco_type, :integer      # 装修房子类型
      t.column :deco_requirement, :string # 装修需求
      t.column :deco_id, :integer         # 装修公司id
      t.column :status, :integer, :default => 0     # 表单状态 判断是新的还是旧的
      t.column :identifying_code, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :booking_decos
  end
end
