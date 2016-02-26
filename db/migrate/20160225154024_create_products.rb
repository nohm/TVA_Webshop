class CreateProducts < ActiveRecord::Migration
	def self.up
    create_table :parts do |t|
			t.integer :category_id
			t.string :name

		  t.timestamps null: false
	  end

	  create_table :partdescriptions do |t|
	  	t.integer :part_id
	  	t.string :title
	  	t.string :value
	  end
  end

  def self.down
    drop_table :parts
    drop_table :partdescriptions
  end
end
