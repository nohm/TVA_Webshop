class AddPreviousUrlToUser < ActiveRecord::Migration
  def change
  	add_column 		:users, :previous_url, :string
  	remove_column :carts, :previous_url
  end
end
