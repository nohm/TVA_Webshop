class CreateDevicePart < ActiveRecord::Migration
  def change
    create_table :device_parts do |t|
    	t.integer :device_id
    	t.integer :part_id
    end
  end
end
