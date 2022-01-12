require 'rails_helper'

describe UserRecipeBookmark, type: :model do
  subject { create(:user_recipe_bookmark) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'belongs to user' do
      let(:user) { create(:user) }
      subject { create(:user_recipe_bookmark, user: user) }
      it { expect(subject.user).to eq(user) }
    end

    describe 'belongs to recipe' do
      let(:recipe) { create(:recipe) }
      subject { create(:user_recipe_bookmark, recipe: recipe) }
      it { expect(subject.recipe).to eq(recipe) }
    end
  end
end
