class AddBrandToParts < ActiveRecord::Migration
  def change
  	add_column :parts, :brand, :string
  end
end
