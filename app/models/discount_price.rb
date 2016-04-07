class DiscountPrice < ActiveRecord::Base
	belongs_to :part

	validates :amount, presence: true
	validates :price,  presence: true
	validates_uniqueness_of :amount, :scope => :part_id
end
