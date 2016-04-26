class Partdescription < ActiveRecord::Base
	belongs_to :part
	has_many :part_subdescriptions, dependent: :destroy

	validates :title, presence: true
	validates_uniqueness_of :title, :scope => :part_id
end
