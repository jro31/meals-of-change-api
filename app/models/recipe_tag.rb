class RecipeTag < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_tags
  belongs_to :tag, inverse_of: :recipe_tags
end
