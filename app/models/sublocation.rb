class Sublocation < ActiveRecord::Base
	belongs_to :location

	validates  :name, presence: true, uniqueness: { scope: [:location_id] }
end
