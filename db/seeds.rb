# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "Julian Lubbers",
                email: "Julian_Lubbers@hotmail.com",
                password:               "foobar",
                password_confirmation:  "foobar")

Product.create!(device_id: 1,
				brand: "Asus",
				model: "X series",
				model_serial: "X53 series")

Product.create!(device_id: 1,
				brand: "Asus",
				model: "X series",
				model_serial: "X53 series")

Product.create!(device_id: 1,
				brand: "Samsung",
				model: "Galaxy Note",
				model_serial: "Note 125")

Device.create!(name: "Laptop")

Category.create!(product_id: 1,
				 name: "HDD")

Part.create!(category_id: 1,
			 name: "2TB"
			 condition: "Good",
			 warranty: "3 months")