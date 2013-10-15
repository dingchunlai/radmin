class CreatePhotoPhotos < ActiveRecord::Migration
  def self.up
    create_table :photo_photos do |t|
    end
  end

  def self.down
    drop_table :photo_photos
  end
end
