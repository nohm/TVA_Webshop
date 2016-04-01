class Coupon < ActiveRecord::Base
	validates :code, presence: true, uniqueness: true
  validates :amount, presence: true

	validate :percent_or_price
  validate :expiration_date_in_future

  

    def atleast_one_id(params)
  		if [params[:category_ids], params[:part_ids], params[:user_ids]].reject(&:blank?).size == 0
    		errors.add(:base, "Specify at least one target.")
        return false
  		else
        return true
      end
    end

  private 

    def percent_or_price
    	if [price, percent].compact.count != 1
    		errors.add(:base, "Specify either percent or price.")
    	end
    end

    def expiration_date_in_future
      if expiration_date < Time.now.utc
        errors.add(:base, "Expiration date is in the past.")
      end
    end
end
