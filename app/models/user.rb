# frozen_string_literal: true

class User < ApplicationRecord
  has_many :items

  has_secure_password

  validates :email, :password, :password_confirmation, presence: true
  validates :password, length: {minimum: 10}
  validates :password, format: {
    with: /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*/,
    message: "must include uppercase and lowercase letters and at least one number"
  }
  validates :email, uniqueness: true

  def token
    JWT.encode({user_id: id}, Rails.application.secrets.secret_key_base)
  end
end
