class AddColumnsToParts < ActiveRecord::Migration
  def change
  	add_column :parts, :condition, 	:string
  	add_column :parts, :warranty,	:string
  end
end
