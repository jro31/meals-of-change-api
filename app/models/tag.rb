class Tag < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
  # Validate name is all lowercase

  has_many :recipe_tags, dependent: :destroy
  has_many :recipes, through: :recipe_tags
end
