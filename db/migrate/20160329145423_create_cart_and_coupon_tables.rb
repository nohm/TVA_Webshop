class CreateCartAndCouponTables < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
    	t.integer :cart_id
    	t.integer :part_id
    	t.integer :amount
    end

    create_table :coupons do |t|
    	t.string :code
    end

    remove_column :carts, :part_id
    remove_column :carts, :amount
  end
end
