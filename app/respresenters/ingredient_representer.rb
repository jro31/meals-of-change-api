class IngredientRepresenter
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def as_json
    {
      amount: ingredient.amount,
      food: ingredient.food,
      preparation: ingredient.preparation,
      optional: ingredient.optional
    }
  end

  private

  attr_reader :ingredient
end
