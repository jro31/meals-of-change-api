require 'rails_helper'

describe Recipe, type: :model do
  subject { create(:recipe) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'belongs to user' do
      let(:user) { create(:user) }
      subject { create(:recipe, user: user) }
      it { expect(subject.user).to eq(user) }
    end

    describe 'has many ingredients' do
      let!(:ingredient) { create(:ingredient, recipe: subject) }
      it { expect(subject.ingredients.first).to eq(ingredient) }

      describe 'dependent destroy' do
        it { expect { subject.destroy }.to change { Ingredient.count }.by(-1) }
      end
    end

    describe 'has many steps' do
      let!(:step) { create(:step, recipe: subject) }
      it { expect(subject.steps.first).to eq(step) }

      describe 'dependent destroy' do
        it { expect { subject.destroy }.to change { Step.count }.by(-1) }
      end
    end

    describe 'has many recipe tags' do
      let!(:recipe_tag) { create(:recipe_tag, recipe: subject) }
      it { expect(subject.recipe_tags.first).to eq(recipe_tag) }

      describe 'dependent destroy' do
        it { expect { subject.destroy }.to change { RecipeTag.count }.by(-1) }
      end
    end

    describe 'has many tags' do
      let(:tag) { create(:tag) }
      let!(:recipe_tag) { create(:recipe_tag, recipe: subject, tag: tag) }
      it { expect(subject.tags.first).to eq(tag) }
    end

    describe 'has one attached small photo' do
      # TODO
      describe 'dependent destroy' do
        # TODO
      end
    end

    describe 'has one attached large photo' do
      # TODO
      describe 'dependent destroy' do
        # TODO
      end
    end
  end

  describe 'validations' do
    describe 'name' do
      let(:name) { 'My Recipe Name' }
      subject { build(:recipe, name: name) }
      describe 'validates presence of name' do
        context 'name is present' do
          it { expect(subject).to be_valid }
        end

        context 'name is not present' do
          let(:name) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:name]).to include('can\'t be blank')
          end
        end
      end
    end
  end

  describe '#small_photo_url' do
    # TODO
  end

  describe '#large_photo_url' do
    # TODO
  end
end
