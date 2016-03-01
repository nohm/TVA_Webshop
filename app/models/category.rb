class Category < ActiveRecord::Base
	belongs_to :product
	has_many :parts, dependent: :destroy

	validates :product_id, 	presence: true
	validates :name, 		presence: true
end
