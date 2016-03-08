class AddDeviceToCategories < ActiveRecord::Migration
  def change
  	add_column :categories, :device_id, :integer
  end
end
