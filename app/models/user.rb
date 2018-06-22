class User < ApplicationRecord
  has_secure_password
  has_many :todos

  enum role: %i[admin manager user].freeze

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }
end
