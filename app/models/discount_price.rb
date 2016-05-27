class DiscountPrice < ActiveRecord::Base
	belongs_to :part

	validate  :higher_amount
	validates :amount, presence: true
	validates_uniqueness_of :amount, :scope => :part_id
	validate  :price_not_nil
	validates :price,  presence: true

	private

	# Checks if amount is higher than 0
	def higher_amount
		if amount <= 0
			errors.add(:amount, "has to be higher than 0")
		end
	end

	# Checks if price is higher than 0
	def price_not_nil
		if price <= 0
			errors.add(:price, "has to be higher than 0")
		end
	end
end
