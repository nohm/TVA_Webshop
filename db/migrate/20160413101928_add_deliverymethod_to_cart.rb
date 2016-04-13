class AddDeliverymethodToCart < ActiveRecord::Migration
  def change
  	add_column :carts, :delivery_method, :string
  end
end
