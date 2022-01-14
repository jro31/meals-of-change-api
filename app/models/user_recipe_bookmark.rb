class UserRecipeBookmark < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validate :validate_unique_association

  private

  def validate_unique_association
    return unless UserRecipeBookmark.where(user: user, recipe: recipe).where.not(id: id).any?

    errors.add(:user, 'has already favourited this recipe')
  end
end
