class Product < ActiveRecord::Base
	attr_accessor :brand_select
	has_many :categories, 		dependent: :destroy
	has_many :parts_products, dependent: :destroy
	has_many :parts, 					:through => :parts_products
	belongs_to :device
	before_save :nil_if_blank

	validates :model, 					presence: true
	validates :model_extended, 	uniqueness: true, allow_blank: true

	protected

	# Method for putting model_extended to nil if it is empty
	def nil_if_blank
		self.model_extended = nil if self.model_extended.empty?
	end
end
