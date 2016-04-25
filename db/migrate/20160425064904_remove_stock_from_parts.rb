class RemoveStockFromParts < ActiveRecord::Migration
  def change
  	remove_column :parts, :stock
  end
end
