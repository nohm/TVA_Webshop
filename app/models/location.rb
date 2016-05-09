class Location < ActiveRecord::Base
	has_many  :part_stocks, 	dependent: :destroy
	has_many 	:sublocations, 	dependent: :destroy
	validates :name, 					presence: true
	validates :city, 					presence: true
	validates :street, 				presence: true
	validates :postal_code,  	presence: true
	validates :country, 		 	presence: true
	validates :phone_number, 	presence: true

	validates_uniqueness_of :street, scope: :city, message: "already exists"
end
