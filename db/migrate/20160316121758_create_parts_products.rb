class CreatePartsProducts < ActiveRecord::Migration
  def change
    create_table :parts_products do |t|
    	t.integer :part_id
    	t.integer :product_id
    end
  end
end
