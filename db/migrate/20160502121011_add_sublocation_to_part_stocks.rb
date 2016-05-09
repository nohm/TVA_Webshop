class AddSublocationToPartStocks < ActiveRecord::Migration
  def change
  	add_column :part_stocks, :sublocation_id, :integer
  end
end
