class User < ActiveRecord::Base
  has_secure_password

	attr_accessor :remember_token
  attr_accessor :current_password

  has_many :cart
  has_many :invoices
  belongs_to :role

	before_save { email.downcase! }

	validates :name, 	presence: true, length: { maximum: 74 }, uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }
  validates :street, presence: true
  validates :city, presence: true
  validates :province, presence: true
  validates :country, presence: true
  validates :postal_code, presence: true
	validates :password, presence: true, length: { minimum: 6 }, :on => :create
  validates :password_confirmation, presence: true, :on => :create
  validate  :current_password_is_correct, on: :update

  def current_password_is_correct
    # Check if the user tried changing his/her password.
    if !password.blank?
      # Get a reference to the user since the "authenticate" method always returns false when calling on itself (for some reason).
      user = User.find_by_id(id)
      # Check if the user CANNOT be authenticated with the entered current password
      if (user.authenticate(current_password) == false)
        # Add an error stating that the current password is incorrect
        errors.add(:current_password, "is incorrect.")
      end
    end
  end

	# Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
  	return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def admin?
    role.name == "Admin"
  end

  def manager?
    role.name == "Manager" || admin?
  end

  def client?
    role.name == "Client" || manager?
  end
end
