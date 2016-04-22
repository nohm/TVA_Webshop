class CreatePartStocks < ActiveRecord::Migration
  def change
    create_table :part_stocks do |t|
    	t.integer :part_id
    	t.integer :location_id
    	t.integer :stock

      t.timestamps null: false
    end
  end
end
