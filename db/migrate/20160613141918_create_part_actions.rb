class CreatePartActions < ActiveRecord::Migration
  def change
    create_table :part_actions do |t|
    	t.integer :part_id
    	t.decimal :price, :precision => 10, :scale => 2

      t.timestamps null: false
    end
  end
end
