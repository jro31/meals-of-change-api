class RecipesRepresenter
  def initialize(recipes)
    @recipes = recipes
  end

  def as_json
    recipes.map do |recipe|
      {
        id: recipe.id,
        author: recipe.user.display_name,
        name: recipe.name,
        time_minutes: recipe.time_minutes,
        photo: recipe.photo_url
      }
    end
  end

  private

  attr_reader :recipes
end
