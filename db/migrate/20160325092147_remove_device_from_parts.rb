class RemoveDeviceFromParts < ActiveRecord::Migration
  def change
  	remove_column :parts, :device_id
  end
end
