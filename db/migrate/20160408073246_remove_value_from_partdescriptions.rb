class RemoveValueFromPartdescriptions < ActiveRecord::Migration
  def change
  	remove_column :partdescriptions, :value
  end
end
