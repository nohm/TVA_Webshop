class Device < ActiveRecord::Base
	has_many :products, dependent: :destroy
	before_save { name.downcase! }
	validates :name, presence: true, uniqueness: { case_sensitive: false }
end
