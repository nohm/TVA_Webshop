class ChangeCostsToDecimal < ActiveRecord::Migration
  def change
  	remove_column :parts, :price
  	add_column :parts, :price_ex, :decimal
  end
end
