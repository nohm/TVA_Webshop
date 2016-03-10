class AddPartnrToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :partnumber, :string
  end
end
