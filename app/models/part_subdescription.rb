class PartSubdescription < ActiveRecord::Base
	belongs_to :partdescription

	validates :title, presence: true
	validates_uniqueness_of :title, :scope => :partdescription_id
	validates :value, presence: true
end
