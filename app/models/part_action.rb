class PartAction < ActiveRecord::Base
	belongs_to :part

	validate  :price_not_nil
	validates :price, presence: true
	# Validations for uploading files to the database. (Check Paperclip gem)
	has_attached_file :actionimage, styles: { thumb: "64x64#", large: "658x398#" }, default_url: "/images/missing.png"
	validates_attachment_content_type :actionimage, content_type: /\Aimage\/.*\Z/
  validates_attachment_file_name :actionimage, matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i]

	# Checks if price is higher than 0
	def price_not_nil
		if price <= 0
			errors.add(:price, "has to be higher than 0")
		end
	end
end
