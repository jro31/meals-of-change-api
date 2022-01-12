class CreateUserRecipeBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_recipe_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
    end
  end
end
