class Delivery < ActiveRecord::Base
	belongs_to :cart_item
	belongs_to :cart_status
end
