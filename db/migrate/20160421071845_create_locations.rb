class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
    	t.string :name
    	t.string :street
    	t.string :postal_code
    	t.string :city
    	t.string :country
    	t.string :phone_number
    end
  end
end
