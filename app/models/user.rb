class User < ApplicationRecord
  has_secure_password

  has_many :recipes, dependent: :destroy

  validates_presence_of :email, :display_name
  validates_uniqueness_of :email, :display_name
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
  validates :display_name, length: { minimum: 4, maximum: 20 }
end
