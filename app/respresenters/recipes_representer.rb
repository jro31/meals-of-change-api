class RecipesRepresenter
  def initialize(recipes)
    @recipes = recipes
  end

  def as_json
    recipes.map do |recipe|
      {
        id: recipe.id,
        author: recipe.user.display_name,
        author_twitter_handle: recipe.user.twitter_handle,
        author_instagram_username: recipe.user.instagram_username,
        name: recipe.name,
        time_minutes: recipe.time_minutes,
        small_photo: recipe.small_photo_url
      }
    end
  end

  private

  attr_reader :recipes
end
