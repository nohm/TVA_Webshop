class CreatePartimages < ActiveRecord::Migration
  def change
    create_table :partimages do |t|
    	t.integer 	:part_id
    	t.string 	:part_image_file_name
    	t.string 	:part_image_content_type
    	t.integer 	:part_image_file_size
    	t.datetime 	:part_image_updated_at
    end
  end
end
