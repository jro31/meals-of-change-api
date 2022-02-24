class User < ApplicationRecord
  has_secure_password

  has_many :recipes, dependent: :destroy
  has_many :user_recipe_bookmarks, dependent: :destroy
  has_many :bookmarked_recipes, through: :user_recipe_bookmarks, source: :recipe

  validates_presence_of :email, :display_name
  validates_uniqueness_of :email, :display_name, case_sensitive: false
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: :password_digest_changed?
  validates :display_name, length: { minimum: 4, maximum: 20 }
  validates :twitter_handle, length: { minimum: 4, maximum: 15 }, allow_nil: true
  validates :twitter_handle, format: { with: /\A[\w]*\z/, message: 'only allows letters, numbers and underscores' }
  validates :instagram_username, length: { minimum: 1, maximum: 30 }, allow_nil: true
  validates :instagram_username, format: { with: /\A[\w.]*\z/, message: 'only allows letters, numbers, full stops and underscores' }

  # TODO - Before validation, the email should be made all lowercase
end
