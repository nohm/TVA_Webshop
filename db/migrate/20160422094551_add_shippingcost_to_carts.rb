class AddShippingcostToCarts < ActiveRecord::Migration
  def change
  	add_column :carts, :shipping_cost, 	:decimal, :precision => 10, :scale => 2
  end
end
