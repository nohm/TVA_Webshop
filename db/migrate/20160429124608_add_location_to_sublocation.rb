class AddLocationToSublocation < ActiveRecord::Migration
  def change
  	add_column :sublocations, :location_id, :integer
  end
end
