class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
  		t.string :device
  		t.string :brand
  		t.string :model
  		t.string :model_serial

  		t.timestamps
  	end
  end
end
