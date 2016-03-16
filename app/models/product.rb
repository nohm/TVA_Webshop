class Product < ActiveRecord::Base
	has_many :categories, dependent: :destroy
	has_and_belongs_to_many :parts
	belongs_to :device
	before_save :nil_if_blank

	attr_accessor :brand_select, :model_select
	validates :brand, 			presence: true
	validates :type_number, presence: true, uniqueness: true
	validates :partnumber, uniqueness: true, :allow_blank => true
	validates :model, presence: true
	validates :model_extended, uniqueness: true, :allow_blank => true

	protected

	def nil_if_blank
		self.model_extended = nil if self.model_extended.empty?
	end
end
