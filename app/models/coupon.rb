class Coupon < ActiveRecord::Base
	validates :code, presence: true, uniqueness: true

	validate :atleast_one_id
	validate :percent_or_price

  private

    def atleast_one_id
  		if [self.category_id, self.part_id, self.user_id].reject(&:blank?).size == 0
    		errors.add(:base, "Specify at least one target.")
  		end 
    end

    def percent_or_price
    	if [price, percent].compact.count != 1
    		errors.add(:base, "Specify either percent or price.")
    	end
    end
end
