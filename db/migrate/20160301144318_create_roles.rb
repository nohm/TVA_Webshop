class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
    	t.string :name
    end

    add_column :users, :role_id, :integer
    Role.new(name: "Admin").save
    Role.new(name: "Manager").save
    Role.new(name: "Client").save
    User.all.each do |u|
    	u.update_attribute(:role_id, Role.first.id)
    end
  end
end
