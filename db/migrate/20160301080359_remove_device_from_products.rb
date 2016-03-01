class RemoveDeviceFromProducts < ActiveRecord::Migration
  def change
  	remove_column :products, :device
  end
end
