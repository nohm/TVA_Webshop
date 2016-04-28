class Product < ActiveRecord::Base
	has_many :categories, 		dependent: :destroy
	has_many :parts_products, dependent: :destroy
	has_many :parts, 					:through => :parts_products
	belongs_to :device
	before_save :nil_if_blank

	attr_accessor :brand_select
	validates :type_number, 		presence: true
	validates :partnumber, 			uniqueness: true, allow_blank: true
	validates :model, 					presence: true
	validates :model_extended, 	uniqueness: true, allow_blank: true

	protected

	def nil_if_blank
		self.model_extended = nil if self.model_extended.empty?
	end
end
