class Invoice < ActiveRecord::Base
	belongs_to :user
	serialize :cart_ids
end
