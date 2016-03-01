class AddImgColumnsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :cimg_file_name,    :string
    add_column :categories, :cimg_content_type, :string
    add_column :categories, :cimg_file_size,    :integer
    add_column :categories, :cimg_updated_at,   :datetime
  end
end
