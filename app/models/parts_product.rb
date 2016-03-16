class PartsProduct < ActiveRecord::Base
	belongs_to :part
	belongs_to :product

	validates_uniqueness_of :product_id, :scope => :part_id, message: "is already connected to this part"
	validates :part_id, 		presence: true
	validates :product_id, 	presence: true
end
