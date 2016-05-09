class CreateCartStatuses < ActiveRecord::Migration
  def change
    create_table :cart_statuses do |t|
      t.string :name

      t.timestamps null: false
    end

    add_column :carts, :tax, 							:decimal, :precision => 10, :scale => 2
    add_column :carts, :subtotal, 				:decimal, :precision => 10, :scale => 2
    add_column :carts, :total, 						:decimal, :precision => 10, :scale => 2
    add_column :carts, :coupon_discount, 	:decimal, :precision => 10, :scale => 2
  end
end
