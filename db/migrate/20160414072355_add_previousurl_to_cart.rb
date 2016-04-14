class AddPreviousurlToCart < ActiveRecord::Migration
  def change
  	add_column :carts, :previous_url, :string
  end
end
