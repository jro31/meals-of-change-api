class RecipesRepresenter
  def initialize(recipes, ids_array = false)
    @recipes = recipes
    @ids_array = ids_array
  end

  def as_json
    if ids_array
      recipes.pluck(:id)
    else
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
  end

  private

  attr_reader :recipes, :ids_array
end
