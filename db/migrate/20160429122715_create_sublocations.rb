class CreateSublocations < ActiveRecord::Migration
  def change
    create_table :sublocations do |t|

      t.string :name
    end
  end
end
