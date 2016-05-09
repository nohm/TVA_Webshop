class CartStatus < ActiveRecord::Base
	has_many :carts

	validates :name, presence: true, uniqueness: { case_sensitive: false }
end
