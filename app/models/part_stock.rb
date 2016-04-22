class PartStock < ActiveRecord::Base
	belongs_to :part

	validates_uniqueness_of :location_id, scope: :part_id, message: "already has a stock for this part"
	validates :stock, 			presence: true
	validates :location_id, presence: true
end
