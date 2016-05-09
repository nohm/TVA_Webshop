class PartStock < ActiveRecord::Base
	belongs_to :part
	belongs_to :location

	validates_uniqueness_of :location_id, scope: :part_id, message: "already has a stock for this part", on: :create
	validates :stock, 					presence: true
	validates :location_id, 		presence: true
	validates :sublocation_id, 	presence: true
end
