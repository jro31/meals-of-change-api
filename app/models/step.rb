class Step < ApplicationRecord
  belongs_to :recipe

  validates_presence_of :position, :instructions
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :position_and_recipe_are_unique

  private

  def position_and_recipe_are_unique
    return unless recipe.steps.where(position: position).any?

    errors.add(:position, 'already exists for this recipe')
  end
end
