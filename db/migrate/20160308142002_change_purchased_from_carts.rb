class ChangePurchasedFromCarts < ActiveRecord::Migration
  def change
  	change_column :carts, :purchased, :boolean, :default => false
  end
end
