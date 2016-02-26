class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :product_id
      t.string :name

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :categories
  end
end
