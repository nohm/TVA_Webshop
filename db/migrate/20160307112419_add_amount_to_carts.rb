class AddAmountToCarts < ActiveRecord::Migration
  def change
  	add_column :carts, :amount, :integer
  end
end
