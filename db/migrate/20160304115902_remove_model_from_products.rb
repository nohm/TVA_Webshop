class RemoveModelFromProducts < ActiveRecord::Migration
  def change
  	remove_column :products, :model
  	rename_column :products, :model_serial, :typenumber
  end
end
