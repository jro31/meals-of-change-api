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

  describe 'validations' do
    describe '#validate_unique_association' do
      let(:user) { create(:user) }
      let(:recipe) { create(:recipe) }
      subject { build(:user_recipe_bookmark, user: user, recipe: recipe) }
      let(:imposter_user) { create(:user) }
      let(:imposter_recipe) { create(:recipe) }
      let!(:imposter_user_recipe_bookmark) { create(:user_recipe_bookmark, user: imposter_user, recipe: imposter_recipe) }
      it { expect(subject).to be_valid }

      context 'the imposter user recipe bookmark has the same user' do
        let(:imposter_user) { user }
        it { expect(subject).to be_valid }
      end

      context 'the imposter user recipe bookmark has the same recipe' do
        let(:imposter_recipe) { recipe }
        it { expect(subject).to be_valid }
      end

      context 'the imposter user recipe bookmark has the same user and recipe' do
        let(:imposter_user) { user }
        let(:imposter_recipe) { recipe }
        it 'is invalid with the correct error' do
          expect(subject).not_to be_valid
          expect(subject.errors.messages[:user]).to include('has already favourited this recipe')
        end
      end
    end
  end
end
