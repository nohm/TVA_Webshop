class RemoveColumnsFromCart < ActiveRecord::Migration
  def change
  	remove_column :carts, :tax
  	remove_column :carts, :coupon_discount
  	remove_column :carts, :subtotal
  	remove_column :carts, :total
  end
end
