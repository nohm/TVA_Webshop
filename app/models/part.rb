class Part < ActiveRecord::Base
	belongs_to :category
	has_many :carts
	has_many :partdescriptions, dependent: :destroy
	has_many :partimages, 		dependent: :destroy

	has_attached_file :partimagefull, styles: { medium: "200x200#", thumb: "64x64#" }, default_url: "/images/missing.png"
	validates_attachment_content_type :partimagefull, content_type: /\Aimage\/.*\Z/
	validates_attachment_file_name :partimagefull, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
	validates :partimagefull, :dimensions => { :width => 300, :height => 300 }

	validates :name, 				presence: true
	validates :condition, 	presence: true
	validates :warranty, 		presence: true
	validates :stock, 			presence: true
	validates :price_ex, 		presence: true
	validates :brand, 			presence: true

	private

end
