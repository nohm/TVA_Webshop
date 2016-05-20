class AddStatusToDelivery < ActiveRecord::Migration
  def change
  	add_column :deliveries, :cart_status_id, :integer
  end
end
