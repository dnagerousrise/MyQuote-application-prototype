class User < ApplicationRecord
  #Enables password hashing and authentication using bcrypt
  has_secure_password
  # A user can have many quotes; deleting a user also deletes their quotes
  has_many :quotes, dependent: :destroy

  # Validations for user attributes
  validates :fname, presence: { message: "First name is required" }
  validates :lname, presence: { message: "Last name is required" }
  # Email must be present and follow a valid format
  validates :email, presence: { message: "Email can't be empty" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  # Password must be present and confirmed if required
  validates :password, presence: true, confirmation: true, if: :password_required?
  # Custom password strength validation
  validate :strong_password_rules, if: :password_required?
  # Determines if password validation is needed (on create or when password is being updated)
  def password_required?
    new_record? || password.present?
  end

  # Checks if the user is suspended
  def suspended?
    status.to_s.downcase == "suspended"
  end
  # Checks if the user is banned
  def banned?
    status.to_s.downcase == "banned"
  end

  private
  # Enforces strong password rules: minimum length, uppercase, number, and symbol
  def strong_password_rules
    return if password.blank? # Let presence validator handle blank case

    if password.length < 6
      errors.add(:password, "must be at least 6 characters long")
    end

    unless password.match?(/[A-Z]/)
      errors.add(:password, "must include at least one uppercase letter")
    end

    unless password.match?(/[0-9]/)
      errors.add(:password, "must include at least one number")
    end

    unless password.match?(/[^A-Za-z0-9]/)
      errors.add(:password, "must include at least one symbol")
    end
  end
end
