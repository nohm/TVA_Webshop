class ChangePricesFromParts < ActiveRecord::Migration
  def change
  	create_table :discount_prices do |t|
    	t.integer :part_id
    	t.integer :amount
    	t.decimal :price, :precision => 10, :scale => 2
    end
  end
end
