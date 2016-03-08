class Cart < ActiveRecord::Base
	belongs_to :user
	belongs_to :part

	validates :amount, presence: true

end
