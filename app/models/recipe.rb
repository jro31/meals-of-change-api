class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :steps, -> { order(:position) }, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags

  validates_presence_of :name
  # Add validation that at least one ingredient must exist? (will make testing a pain)
  # Add validation that at least one step must exist? (will make testing a pain)
  # Add validation that cannot have more than 15 tags
end
