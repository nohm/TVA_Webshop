class AddColumnsToCartItems < ActiveRecord::Migration
  def change
  	add_column :cart_items, :name, 						:string
  	add_column :cart_items, :discount_tier, 	:int
  	add_column :cart_items, :price_discount, 	:decimal, :precision => 10, :scale => 2
  end
end
