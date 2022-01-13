class RecipeRepresenter
  def initialize(recipe)
    @recipe = recipe
  end

  def as_json
    {
      id: recipe.id,
      user: UserRepresenter.new(recipe.user, false).as_json,
      name: recipe.name,
      time_minutes: recipe.time_minutes,
      preface: recipe.preface,
      ingredients: ingredients_array,
      steps: steps_array,
      tags: tags_array,
      small_photo: recipe.small_photo_url,
      large_photo: recipe.large_photo_url,
    }
  end

  private

  attr_reader :recipe

  def ingredients_array
    recipe.ingredients.map { |ingredient| IngredientRepresenter.new(ingredient).as_json }
  end

  def steps_array
    recipe.steps.order(:position).map { |step| StepRepresenter.new(step).as_json }
  end

  def tags_array
    recipe.tags.order(:name).map { |tag| TagRepresenter.new(tag).as_json }
  end
end
