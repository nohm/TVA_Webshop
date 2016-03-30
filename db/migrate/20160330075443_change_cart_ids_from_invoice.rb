class ChangeCartIdsFromInvoice < ActiveRecord::Migration
  def change
  	remove_column :invoices, :cart_ids
  	add_column :invoices, :cart_id, :integer
  end
end
