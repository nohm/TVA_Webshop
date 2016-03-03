class Part < ActiveRecord::Base
	belongs_to :category
	has_many :partdescriptions, dependent: :destroy
	has_many :partimages, 		dependent: :destroy

	validates :name, 			presence: true
	validates :condition, 		presence: true
	validates :warranty, 		presence: true
	validates :stock, 			presence: true
	validates :price_ex, 		presence: true
end
