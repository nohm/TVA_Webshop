class AddDefaultToCart < ActiveRecord::Migration
  def change
  	change_column :coupons, :amount, 			:integer, default: 0
  end
end
