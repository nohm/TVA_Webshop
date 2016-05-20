class CartStatus < ActiveRecord::Base
	has_many :carts
	has_many :deliveries
	validates :name, presence: true, uniqueness: { case_sensitive: false }
end
