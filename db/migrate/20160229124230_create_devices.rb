class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
    	t.name
    end
  end
end
