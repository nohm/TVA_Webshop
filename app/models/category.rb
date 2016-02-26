class Category < ActiveRecord::Base
	belongs_to :product
	has_many :part

	validates :product_id, presence: true
	validates :name, presence: true
end
