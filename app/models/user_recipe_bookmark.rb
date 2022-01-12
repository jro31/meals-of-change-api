class UserRecipeBookmark < ApplicationRecord
  belongs_to :user#, inverse_of: :user_recipe_bookmarks
  belongs_to :recipe#, inverse_of: :user_recipe_bookmarks

  # TODO - Validate uniqueness of assocations
end
