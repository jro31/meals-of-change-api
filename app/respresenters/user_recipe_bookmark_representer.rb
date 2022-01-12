class UserRecipeBookmarkRepresenter
  def initialize(user_recipe_bookmark)
    @user_recipe_bookmark = user_recipe_bookmark
  end

  def as_json
    {
      id: user_recipe_bookmark.id,
      user_id: user_recipe_bookmark.user_id,
      recipe_id: user_recipe_bookmark.recipe_id
    }
  end

  private

  attr_reader :user_recipe_bookmark
end
