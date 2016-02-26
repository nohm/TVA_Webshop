class Product < ActiveRecord::Base
	has_many :category

	attr_accessor :device_select, :brand_select, :model_select
	validates :device, 			presence: true
	validates :brand, 			presence: true
	validates :model, 			presence: true
	validates :model_serial, 	presence: true
end
