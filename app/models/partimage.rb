class Partimage < ActiveRecord::Base
	belongs_to :part
	has_attached_file :pimg, styles: { medium: "200x200#", thumb: "64x64#" }, default_url: "/images/missing.png"
	validates_attachment_content_type :pimg, content_type: /\Aimage\/.*\Z/
	validates_attachment_file_name :pimg, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
	validates :pimg, attachment_presence: true
end
