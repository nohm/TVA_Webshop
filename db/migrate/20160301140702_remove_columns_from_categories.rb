class RemoveColumnsFromCategories < ActiveRecord::Migration
  def change
  	remove_column :categories, :brand
  	remove_column :categories, :condition
  	remove_column :categories, :warranty
  end
end
