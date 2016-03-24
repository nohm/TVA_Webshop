class ChangeCartIdsFromInvoices < ActiveRecord::Migration
  def change
  	change_column :invoices, :cart_ids, :text
  end
end
