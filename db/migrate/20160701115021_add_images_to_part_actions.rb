class AddImagesToPartActions < ActiveRecord::Migration
  def change
  	add_column :part_actions, :actionimage_file_name,    :string
    add_column :part_actions, :actionimage_content_type, :string
    add_column :part_actions, :actionimage_file_size,    :integer
    add_column :part_actions, :actionimage_updated_at,   :datetime
    add_column :part_actions, :active,									 :boolean, default: false
  end
end
