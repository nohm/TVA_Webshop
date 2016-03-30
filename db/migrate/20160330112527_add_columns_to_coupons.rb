class AddColumnsToCoupons < ActiveRecord::Migration
  def change
  	add_column :coupons, :category_id, 	:integer
  	add_column :coupons, :part_id, 			:integer
  	add_column :coupons, :user_id, 			:integer
  	add_column :coupons, :amount, 			:integer
  	add_column :coupons, :percent, 			:decimal, :precision => 10, :scale => 2
  	add_column :coupons, :price, 				:decimal, :precision => 10, :scale => 2
  end
end
