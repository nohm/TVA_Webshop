class AddColumnsToDeliveries < ActiveRecord::Migration
  def change
  	rename_column :deliveries, :sublocation_id, :shipping_from_location
  	add_column 		:deliveries, :shipping_to_location, :integer
  	add_column 		:deliveries, :shipping_to_user, :integer
  end
end
