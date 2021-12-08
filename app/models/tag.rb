class Tag < ApplicationRecord
  validates_presence_of :name

  has_many :recipe_tags, dependent: :destroy
  has_many :recipes, through: :recipe_tags
end
