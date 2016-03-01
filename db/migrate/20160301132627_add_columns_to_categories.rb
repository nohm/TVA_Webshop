class AddColumnsToCategories < ActiveRecord::Migration
  def change
  	add_column :categories, :brand, 	:string
  	add_column :categories, :condition, :string
  	add_column :categories, :garantie, 	:string
  end
end
