class AddPriceToParts < ActiveRecord::Migration
  def change
  	add_column :parts, :price, 	:integer
  	add_column :parts, :stock,	:integer
  end
end
