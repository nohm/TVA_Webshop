class AddCouponsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :used_coupon_ids, 	:integer, array: true, default: []
  end
end
