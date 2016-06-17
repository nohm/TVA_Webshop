class Part < ActiveRecord::Base
	attr_accessor :price, :condition_select, :location_id, :stock, :sublocation_id, :brand_select

	belongs_to :category
	has_many :products, 						through: 	 :parts_products
	has_many :parts_products, 			dependent: :destroy
	has_many :cart_items,						dependent: :destroy
	has_many :partdescriptions, 		dependent: :destroy
	has_many :partimages, 					dependent: :destroy
	has_many :discount_prices, 			dependent: :destroy
	has_many :part_stocks,					dependent: :destroy
	has_many :part_recommendation, 	dependent: :destroy
	has_many :part_actions,					dependent: :destroy

	# Validations for uploading files to the database. (Check Paperclip gem)
	has_attached_file :partimagefull, styles: { thumb: "64x64#", small: "100x100#" }, default_url: "/images/missing.png"
	validates_attachment_content_type :partimagefull, content_type: /\Aimage\/.*\Z/
  validates_attachment_file_name :partimagefull, matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i]
  # Custom validation for checking that an image is atleast 300x300
	validates :partimagefull, dimensions: { width: 300, height: 300 }

	validates :name, 						presence: true
	validates :weight, 					presence: true
	validates :location_id, 		presence: true, on: :create
	validates :sublocation_id, 	presence: true, on: :create
	validates :stock, 					presence: true, on: :create
	validates :price, 					presence: true, format: { with: /\d+(?:\.\d{0,2})?/ }, on: :create
end
