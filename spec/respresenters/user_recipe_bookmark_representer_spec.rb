require 'rails_helper'

describe UserRecipeBookmarkRepresenter do
  let(:user) { create(:user, id: 666) }
  let(:recipe) { create(:recipe, id: 999) }
  let(:user_recipe_bookmark) { create(:user_recipe_bookmark, user: user, recipe: recipe) }
  describe 'as_json' do
    subject { UserRecipeBookmarkRepresenter.new(user_recipe_bookmark).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq({
        id: user_recipe_bookmark.id,
        user_id: 666,
        recipe_id: 999
      })
    end
  end
end
