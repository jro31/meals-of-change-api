class User < ApplicationRecord
  has_secure_password

  has_many :recipes, dependent: :destroy
  has_many :user_recipe_bookmarks, dependent: :destroy
  has_many :bookmarked_recipes, through: :user_recipe_bookmarks, source: :recipe

  validates_presence_of :email, :display_name
  validates_uniqueness_of :email, :display_name
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
  validates :display_name, length: { minimum: 4, maximum: 20 }
  # TODO - Validate twitter_handle is between 4 - 15 characters
  # TODO - Validate twitter_handle is only A-Z, 0-9 and underscores (no spaces/dashes)
  # TODO - Validate instagram_username is no more than 30 characters
  # TODO - Validate instagram_username only contains letters, numbers, full-stops and underscores
end
