class Part < ActiveRecord::Base
	belongs_to :category
	has_many :partdescriptions, dependent: :destroy

	validates :name, 		presence: true
	validates :condition, 	presence: true
	validates :warranty, 	presence: true
end
