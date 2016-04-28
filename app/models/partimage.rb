class Partimage < ActiveRecord::Base
	belongs_to :part
	has_attached_file :pimg, styles: { large: "300x300#", thumb: "64x64#" }, default_url: "/images/missing.png"
	validates_attachment_content_type :pimg, content_type: /\Aimage\/.*\Z/
	validates_attachment_file_name :pimg, matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i]
	validates :pimg, dimensions: { width: 300, height: 300 }
	validates :pimg, attachment_presence: true
end
