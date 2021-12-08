class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates_presence_of :food
end
