class RenameColumnFromCategories < ActiveRecord::Migration
  def change
  	rename_column :categories, :garantie, :warranty
  end
end
