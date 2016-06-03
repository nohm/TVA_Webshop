class CreatePartRecommendations < ActiveRecord::Migration
  def change
    create_table :part_recommendations do |t|
    	t.integer :part_id

    	t.timestamps null: false
    end
  end
end
