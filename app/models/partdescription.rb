class Partdescription < ActiveRecord::Base
	belongs_to :part

	validates :title, presence: true
	validates :value, presence: true
end
