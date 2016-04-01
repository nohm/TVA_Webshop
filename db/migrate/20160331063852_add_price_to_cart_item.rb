class AddPriceToCartItem < ActiveRecord::Migration
  def change
  	add_column :cart_items, :price, :decimal, :precision => 10, :scale => 2
  end
end
