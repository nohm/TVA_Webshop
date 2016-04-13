class DiscountPrice < ActiveRecord::Base
	belongs_to :part

	validate  :higher_amount
	validates :amount, presence: true
	validates_uniqueness_of :amount, :scope => :part_id
	validate  :price_not_nil
	validates :price,  presence: true

	private

	def higher_amount
		if amount <= 0
			errors.add(:amount, "has to be higher than 1")
		end
	end

	def price_not_nil
		if price == 0
			errors.add(:price, "has to atleast be higher than 0")
		end
	end
end
