class AddSalepricesToCartItems < ActiveRecord::Migration
  def change
  	add_column :cart_items, :price_sale,	:decimal, :precision => 10, :scale => 2
  end
end
