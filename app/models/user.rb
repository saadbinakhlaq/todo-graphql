require 'bcrypt'

class User < ApplicationRecord
  include BCrypt
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, length: {minimum: 8, maximum: 72}

  has_many :lists, dependent: :destroy
  has_many :external_access_tokens, dependent: :destroy
end
