class Coupon < ActiveRecord::Base
	validates :code, presence: true, uniqueness: true
  validates :amount, presence: true

  validate :atleast_one_id
	validate :percent_or_price
  validate :expiration_date_in_future
  validate :categories_exist
  validate :parts_exist
  validate :users_exist

  private 

  def atleast_one_id
  	if [category_ids, part_ids, user_ids].reject(&:blank?).size == 0
    	errors.add(:base, "Specify at least one target.")
    end
  end

  def parts_exist
    no_parts = []
    part_ids.each do |part_id|
      if Part.where(:id => part_id).empty?
        no_parts << part_id
      end
    end
    if no_parts.length > 0
      errors.add(:part_ids, "don't exist: #{no_parts.join(', ')}")
    end
  end

  def categories_exist
    no_categories = []
    category_ids.each do |category_id|
      if Category.where(:id => category_id).empty?
        no_categories << category_id
      end
    end
    if no_categories.length > 0
      errors.add(:category_ids, "don't exist: #{no_categories.join(', ')}")
    end
  end

  def users_exist
    no_users = []
    user_ids.each do |user_id|
      if User.where(:id => user_id).empty?
        no_users << user_id
      end
    end
    if no_users.length > 0
      errors.add(:user_ids, "don't exist: #{no_users.join(', ')}")
    end
  end

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
