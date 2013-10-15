class Adddecoinfo < ActiveRecord::Migration
  def self.up

    add_column :HEJIA_COMPANY, :primary_style, :integer
    add_column :HEJIA_COMPANY, :primary_vantag, :integer
    add_column :HEJIA_COMPANY, :confirm, :integer, :default => 0
    DecoInfo.update_all(:confirm => 1)
  end

  def self.down

    remove_column :HEJIA_COMPANY, :primary_style
    remove_column :HEJIA_COMPANY, :primary_vantag
    remove_column :HEJIA_COMPANY, :confirm
  end
end
