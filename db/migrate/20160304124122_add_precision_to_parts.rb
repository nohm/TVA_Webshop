class AddPrecisionToParts < ActiveRecord::Migration
  def change
  	change_column :parts, :price_ex, :decimal, :precision => 10, :scale => 2
  end
end
