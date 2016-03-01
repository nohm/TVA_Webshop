class AddDeviceidToProducts < ActiveRecord::Migration
  def change
   add_column :products, :device_id, :integer
  end
end
