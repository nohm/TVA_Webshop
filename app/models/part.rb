class Part < ActiveRecord::Base
	attr_accessor :price, :condition_select, :location_id, :stock

	belongs_to :category
	has_many :parts_products, 	dependent: :destroy
	has_many :products, 				through: 	 :parts_products
	has_many :cart_items,				dependent: :destroy
	has_many :partdescriptions, dependent: :destroy
	has_many :partimages, 			dependent: :destroy
	has_many :discount_prices, 	dependent: :destroy
	has_many :part_stocks,			dependent: :destroy

	has_attached_file :partimagefull, styles: { thumb: "64x64#" }, default_url: "/images/missing.png"
	validates_attachment_content_type :partimagefull, content_type: /\Aimage\/.*\Z/
	validates_attachment_file_name :partimagefull, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
	validates :partimagefull, dimensions: { width: 300, height: 300 }

	validates :name, 				presence: true
	validates :brand, 			presence: true
	validates :warranty, 		presence: true
	validates :weight, 			presence: true
	validates :location_id, presence: true, on: :create
	validates :stock, 			presence: true, on: :create
	validates :price, 			presence: true, format: { with: /\d+(?:\.\d{0,2})?/ }, on: :create

	private

end
