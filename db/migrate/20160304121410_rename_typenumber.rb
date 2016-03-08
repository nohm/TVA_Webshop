class RenameTypenumber < ActiveRecord::Migration
  def change
  	rename_column :products, :typenumber, :serial
  end
end
