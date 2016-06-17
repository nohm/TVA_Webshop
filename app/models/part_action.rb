class PartAction < ActiveRecord::Base
	belongs_to :part

	validate  :price_not_nil
	validates :price, presence: true

	# Checks if price is higher than 0
	def price_not_nil
		if price <= 0
			errors.add(:price, "has to be higher than 0")
		end
	end
end
