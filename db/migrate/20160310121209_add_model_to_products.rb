class AddModelToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :model, :string
  	add_column :products, :model_extended, :string
  end
end
