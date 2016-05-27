class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token, :current_password 

  has_many :cart,       dependent: :destroy
  has_many :invoices,   dependent: :destroy
  has_many :reminders,  dependent: :destroy
  belongs_to :role

	before_save { email.downcase! }
  before_create :create_activation_digest

	validates :name, 	presence: true, length: { maximum: 74 }, uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email,       presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :street,      presence: true
  validates :city,        presence: true
  validates :postal_code, presence: true
  has_secure_password
	validates :password,    length: { minimum: 6 }, on: :create
  validate  :current_password_is_correct,      on: :update

  # Check if passwords match when updating user settings.
  def current_password_is_correct
    # Get a reference to the user since the "authenticate" method always returns false when calling on itself (for some reason).
    user = User.find_by_id(id)
    
    # Checks if user.used_coupon_ids is equal to used_coupon_ids (To check if you're only updating settings).
    if ((user.used_coupon_ids <=> used_coupon_ids) == 0)
      url = $request.path_info
      # Checks to see if the URL doesn't include 'password_reset' (To check if you're only updating settings).
      unless url.include?('password_reset')
        # Check if the user CANNOT be authenticated with the entered current password
        if (user.authenticate(current_password) == false)
          errors.add(:current_password, "is incorrect.")
        end
      end
    end
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Checks if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
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
