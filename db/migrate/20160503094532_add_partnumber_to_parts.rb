class AddPartnumberToParts < ActiveRecord::Migration
  def change
  	remove_column :products, :partnumber
  	remove_column :products, :type_number
  	add_column 		:parts, 	 :partnumber, :string
  end
end
