class AddCouponToCart < ActiveRecord::Migration
  def change
  	add_column :carts, :coupon_code, :string
  end
end
