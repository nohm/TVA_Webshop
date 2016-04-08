class CreatePartSubdescriptions < ActiveRecord::Migration
  def change
    create_table :part_subdescriptions do |t|
    	t.integer :partdescription_id
	  	t.string :title
	  	t.string :value
    end
  end
end
