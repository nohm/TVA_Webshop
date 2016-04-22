class RenameColumnsFromCartItems < ActiveRecord::Migration
  def change
  	rename_column :cart_items, :price_sale, :price_coupon_discount
  	rename_column :cart_items, :price_discount, :price_tier_discount
  end
end

