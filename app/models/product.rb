class Product < ActiveRecord::Base
	has_many :categories, dependent: :destroy
	belongs_to :device

	attr_accessor :brand_select, :model_select
	validates :brand, 			presence: true
	validates :model, 			presence: true
	validates :model_serial, 	presence: true
end
