class CreateReminder < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
    	t.integer :user_id
    	t.integer :part_id

    	t.timestamps null: false
    end
  end
end
