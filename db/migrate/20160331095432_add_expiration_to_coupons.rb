class AddExpirationToCoupons < ActiveRecord::Migration
  def change
  	rename_column :coupons, :category_id, :category_ids
  	rename_column :coupons, :part_id, :part_ids
  	rename_column :coupons, :user_id, :user_ids
  	add_column :coupons, :expiration_date, :datetime
  end
end
