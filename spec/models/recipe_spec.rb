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

    describe 'has many user recipe bookmarks' do
      let!(:user_recipe_bookmark) { create(:user_recipe_bookmark, recipe: subject) }
      it { expect(subject.user_recipe_bookmarks.first).to eq(user_recipe_bookmark) }

      describe 'dependent destroy' do
        it { expect { subject.destroy }.to change { UserRecipeBookmark.count }.by(-1) }
      end
    end

    describe 'has many bookmarked users' do
      let(:user) { create(:user) }
      let!(:user_recipe_bookmark) { create(:user_recipe_bookmark, user: user, recipe: subject) }
      it { expect(subject.bookmarked_users.first).to eq(user) }
    end

    describe 'has one attached small photo' do
      # TODO
      describe 'destroying the recipes purges the photo' do
        # TODO
      end
    end

    describe 'has one attached large photo' do
      # TODO
      describe 'destroying the recipes purges the photo' do
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

    describe 'preface' do
      subject { build(:recipe, preface: preface) }
      describe 'validates length of preface' do
        context 'preface is 2500 characters' do
          let(:preface) { Faker::Lorem.characters(number: 2500) }
          it { expect(subject).to be_valid }
        end

        context 'preface is 2501 characters' do
          let(:preface) { Faker::Lorem.characters(number: 2501) }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:preface]).to include('is too long (maximum is 2500 characters)')
          end
        end
      end
    end

    describe 'tags' do
      subject { build(:recipe) }
      describe '#validate_number_of_tags' do
        context 'recipe has 9 tags' do
          let!(:recipe_tags) { create_list(:recipe_tag, 9, recipe: subject) }
          it { expect(subject).to be_valid }
        end

        context 'recipe has 10 tags' do
          let!(:recipe_tags) { create_list(:recipe_tag, 10, recipe: subject) }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:base]).to include('cannot have more than 9 tags')
          end
        end
      end
    end
  end

  describe '#search_by_recipe_name_ingredient_food_and_tag_name' do
    let(:recipe_1) { create(:recipe, name: 'Cashew sauce pasta') }
    let!(:recipe_1_ingredient_1) { create(:ingredient, recipe: recipe_1, food: 'Cashews') }
    let!(:recipe_1_ingredient_2) { create(:ingredient, recipe: recipe_1, food: 'Gluten-free wholewheat pasta' ) }

    let(:recipe_2) { create(:recipe, name: 'Italian pizza') }
    let!(:recipe_2_ingredient_1) { create(:ingredient, recipe: recipe_2, food: 'Tomato sauce') }
    let!(:recipe_2_ingredient_2) { create(:ingredient, recipe: recipe_2, food: 'Wholewheat flour' ) }

    let(:recipe_3) { create(:recipe, name: 'Garlic-roasted tomatoes with basil and chickpeas on wholewheat spaghetti') }
    let!(:recipe_3_ingredient_1) { create(:ingredient, recipe: recipe_3, food: 'Sea salt') }
    let!(:recipe_3_ingredient_2) { create(:ingredient, recipe: recipe_3, food: 'Onion powder' ) }

    let(:recipe_4) { create(:recipe, name: 'Healthy banana ice-cream') }
    let!(:recipe_4_ingredient_1) { create(:ingredient, recipe: recipe_4, food: 'Bananas') }
    let!(:recipe_4_ingredient_2) { create(:ingredient, recipe: recipe_4, food: 'Italian vanilla essence' ) }

    let(:tag_1) { create(:tag, name: 'italian') }
    let!(:tag_1_recipe_1_recipe_tag) { create(:recipe_tag, recipe: recipe_1, tag: tag_1) }
    let!(:tag_1_recipe_4_recipe_tag) { create(:recipe_tag, recipe: recipe_4, tag: tag_1) }

    let(:tag_2) { create(:tag, name: 'main') }
    let!(:tag_2_recipe_1_recipe_tag) { create(:recipe_tag, recipe: recipe_1, tag: tag_2) }
    let!(:tag_2_recipe_2_recipe_tag) { create(:recipe_tag, recipe: recipe_2, tag: tag_2) }
    let!(:tag_2_recipe_3_recipe_tag) { create(:recipe_tag, recipe: recipe_3, tag: tag_2) }

    let(:tag_3) { create(:tag, name: 'gluten-free') }
    let!(:tag_3_recipe_4_recipe_tag) { create(:recipe_tag, recipe: recipe_4, tag: tag_3) }

    let(:tag_4) { create(:tag, name: 'healthy') }
    let!(:tag_4_recipe_1_recipe_tag) { create(:recipe_tag, recipe: recipe_1, tag: tag_4) }
    let!(:tag_4_recipe_3_recipe_tag) { create(:recipe_tag, recipe: recipe_3, tag: tag_4) }

    let(:query) { '' }
    subject { Recipe.search_by_recipe_name_ingredient_food_and_tag_name(query) }

    context 'query is an empty string' do
      it { expect(subject).to eq([]) }
    end

    context 'Tomato' do
      let(:query) { 'Tomato' }
      it 'returns recipe 3 (title), then recipe 2 (ingredient)' do
        expect(subject).to eq([recipe_3, recipe_2])
      end
    end

    context 'tomato' do
      let(:query) { 'tomato' }
      it 'returns recipe 3 (title), then recipe 2 (ingredient)' do
        expect(subject).to eq([recipe_3, recipe_2])
      end
    end

    context 'healthy' do
      let(:query) { 'healthy' }
      it 'returns recipe 4 (title), then recipes 1 and 3 (tags)' do
        expect(subject).to eq([recipe_4, recipe_1, recipe_3])
      end
    end

    context 'wholewheat' do
      let(:query) { 'wholewheat' }
      it 'returns recipe 3 (title), then recipes 1 and 2 (ingredients)' do
        expect(subject).to eq([recipe_3, recipe_1, recipe_2])
      end
    end

    context 'italian' do
      let(:query) { 'italian' }
      it 'returns recipe 2 (title), then recipe 4 (tag and ingredients), then recipe 1 (tag)' do
        expect(subject).to eq([recipe_2, recipe_4, recipe_1])
      end
    end

    context 'italian tomato' do
      let(:query) { 'italian tomato' }
      it 'returns recipe 2 (\'Italian\' in title, \'Tomato\' in ingredients)' do
        expect(subject).to eq([recipe_2])
      end

      context 'recipe 3 has \'italian\' tag' do
        let!(:tag_1_recipe_3_recipe_tag) { create(:recipe_tag, recipe: recipe_3, tag: tag_1) }
        it 'returns recipe 2 (\'Italian\' in title, \'tomatoes\' in ingredients), then recipe 3 (\'tomatoes\' in title, \'italian\' tag)' do
          expect(subject).to eq([recipe_2, recipe_3])
        end
      end
    end

    context 'roasted onion' do
      let(:query) { 'roasted onion' }
      it 'returns recipe 3 (\'roasted\' in title, \'Onion\' in ingredients)' do
        expect(subject).to eq([recipe_3])
      end
    end

    context 'roasted vanilla' do
      let(:query) { 'roasted vanilla' }
      it 'returns nothing' do
        expect(subject).to eq([])
      end
    end

    context 'wholewheat flour' do
      let(:query) { 'wholewheat flour' }
      it 'returns just recipe 2 (ingredients)' do
        expect(subject).to eq([recipe_2])
      end
    end

    context 'main pasta' do
      let(:query) { 'main pasta' }
      it 'returns just recipe 1 (\'main\' tag, \'pasta\' title and ingredients)' do
        expect(subject).to eq([recipe_1])
      end
    end

    context 'gluten-free' do
      let(:query) { 'gluten-free' }
      it 'returns recipe 4 (tag), then recipe 1 (ingredients)' do
        expect(subject).to eq([recipe_4, recipe_1])
      end
    end

    context 'gluten free ice cream' do
      let(:query) { 'gluten free ice cream' }
      it 'returns just recipe 4 (\'gluten-free\' tag, \'ice-cream\' title)' do
        expect(subject).to eq([recipe_4])
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
