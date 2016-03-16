class AddFkToPartsAndProducts < ActiveRecord::Migration
  def change
  	add_column :products, :part_id, :integer
  	add_column :parts, :product_id, :integer
  end
end
