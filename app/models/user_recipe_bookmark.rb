class UserRecipeBookmark < ApplicationRecord
  belongs_to :user#, inverse_of: :user_recipe_bookmarks
  belongs_to :recipe#, inverse_of: :user_recipe_bookmarks

  validate :validate_unique_association

  private

  def validate_unique_association
    return unless UserRecipeBookmark.where(user: user, recipe: recipe).where.not(id: id).any?

    errors.add(:user, 'has already favourited this recipe')
  end
end
