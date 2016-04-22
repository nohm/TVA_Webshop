class AddLocationToCart < ActiveRecord::Migration
  def change
  	add_column :carts, :location_id, :integer
  end
end
