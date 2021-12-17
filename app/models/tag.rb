class Tag < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

  has_many :recipe_tags, dependent: :destroy
  has_many :recipes, through: :recipe_tags
end
