class RemoveProvinceFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :province
  end
end
