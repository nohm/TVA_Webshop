class Product < ActiveRecord::Base
	has_many :categories, dependent: :destroy
	belongs_to :device

	attr_accessor :brand_select, :model_select
	validates :brand, 			presence: true
	validates :type_number, presence: true, uniqueness: true
end
