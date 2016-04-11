class ChangeBooleanFromUsers < ActiveRecord::Migration
  def change
  	change_column :users, :activated, :boolean, default: false
  end
end
