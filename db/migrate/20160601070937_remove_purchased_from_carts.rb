class RemovePurchasedFromCarts < ActiveRecord::Migration
  def change
  	remove_column :carts, :purchased
  end
end
