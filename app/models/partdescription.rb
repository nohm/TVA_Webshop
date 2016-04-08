class Partdescription < ActiveRecord::Base
	belongs_to :part
	has_many :part_subdescriptions

	validates :title, presence: true
end
