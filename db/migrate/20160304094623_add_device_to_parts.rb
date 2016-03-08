class AddDeviceToParts < ActiveRecord::Migration
  def change
  	add_column :parts, :device_id, :integer
  end
end
