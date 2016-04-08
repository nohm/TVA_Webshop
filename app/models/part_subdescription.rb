class PartSubdescription < ActiveRecord::Base
	belongs_to :partdescription

	validates :title, presence: true
	validates :value, presence: true
end
