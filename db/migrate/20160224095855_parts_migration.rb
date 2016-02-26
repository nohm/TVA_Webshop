class PartsMigration < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
  		t.string :device
  		t.string :brand
  		t.string :model
  		t.string :model_serial

  		t.timestamps
  	end
  end

  def self.down
    drop_table :products
  end

end
