class AddArraysToCoupons < ActiveRecord::Migration
  def change
  	remove_column :coupons, :category_ids
  	remove_column :coupons, :part_ids
  	remove_column :coupons, :user_ids
  	add_column :coupons, :category_ids, 	:integer, array: true, default: []
  	add_column :coupons, :part_ids, 			:integer, array: true, default: []
  	add_column :coupons, :user_ids, 			:integer, array: true, default: []
  end
end
