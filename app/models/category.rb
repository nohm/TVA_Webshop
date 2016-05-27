class Category < ActiveRecord::Base
	belongs_to :product
	belongs_to :device
	has_many :parts, dependent: :destroy

	# Validations for uploading files to the database. (Check Paperclip gem)
	has_attached_file :cimg, styles: { medium: "200x200#" }, default_url: "/images/missing.png"
	validates_attachment_content_type :cimg, content_type: /\Aimage\/.*\Z/
	validates_attachment_file_name :cimg, matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i]
	validates :cimg, attachment_presence: true
	# Custom validation for checking that an image is atleast 300x300
	validates :cimg, dimensions: { width: 300, height: 300 }, on: :create

	validates :name, presence: true
	validates_uniqueness_of :name, :scope => :device_id
end
