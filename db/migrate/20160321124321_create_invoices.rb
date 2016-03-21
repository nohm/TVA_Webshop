class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
    	t.integer :user_id
      t.timestamps null: false
    end
  end
end
