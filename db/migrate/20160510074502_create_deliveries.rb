class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
    	t.integer :cart_item_id
    	t.integer :sublocation_id
    	t.integer :amount
    end
  end
end
