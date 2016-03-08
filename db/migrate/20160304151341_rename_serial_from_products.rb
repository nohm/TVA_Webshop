class RenameSerialFromProducts < ActiveRecord::Migration
  def change
  	rename_column :products, :serial, :type_number
  end
end
