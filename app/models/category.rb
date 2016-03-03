class Category < ActiveRecord::Base
	belongs_to :product
	has_many :parts, dependent: :destroy

	has_attached_file :cimg, styles: { medium: "200x200#", thumb: "64x64#" }, default_url: "/images/missing.png"
	validates_attachment_content_type :cimg, content_type: /\Aimage\/.*\Z/
	validates_attachment_file_name :cimg, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
	validates :product_id, 			presence: true
	validates :name, 				presence: true
	validates :cimg, attachment_presence: true
end
