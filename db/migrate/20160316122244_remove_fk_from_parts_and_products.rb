class RemoveFkFromPartsAndProducts < ActiveRecord::Migration
  def change
  	remove_column :products, :part_id
  	remove_column :parts, :product_id
  end
end
