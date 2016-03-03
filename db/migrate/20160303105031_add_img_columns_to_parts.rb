class AddImgColumnsToParts < ActiveRecord::Migration
  def change
  	add_column :parts, :partimagefull_file_name,    :string
    add_column :parts, :partimagefull_content_type, :string
    add_column :parts, :partimagefull_file_size,    :integer
    add_column :parts, :partimagefull_updated_at,   :datetime
  end
end
