class AddCartIdsToInvoices < ActiveRecord::Migration
  def change
  	add_column :invoices, :cart_ids, :string
  end
end
