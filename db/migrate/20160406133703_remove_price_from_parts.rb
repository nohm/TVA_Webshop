class RemovePriceFromParts < ActiveRecord::Migration
  def change
  	remove_column :parts, :price_ex
  end
end
