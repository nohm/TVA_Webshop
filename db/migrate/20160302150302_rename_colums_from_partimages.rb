class RenameColumsFromPartimages < ActiveRecord::Migration
  def change
  	rename_column :partimages, :part_image_file_name, :pimg_file_name
  	rename_column :partimages, :part_image_content_type, :pimg_content_type
  	rename_column :partimages, :part_image_file_size, :pimg_file_size
  	rename_column :partimages, :part_image_updated_at, :pimg_updated_at
  end
end
