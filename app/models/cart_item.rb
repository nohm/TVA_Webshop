class CartItem < ActiveRecord::Base
	belongs_to :cart
	belongs_to :part
	has_many 	 :deliveries, dependent: :destroy
end
