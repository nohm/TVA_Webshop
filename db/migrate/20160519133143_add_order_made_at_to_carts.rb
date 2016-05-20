class AddOrderMadeAtToCarts < ActiveRecord::Migration
  def change
  	add_column :carts, :order_made_at, :datetime
  end
end
