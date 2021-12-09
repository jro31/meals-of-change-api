require 'rails_helper'

describe RecipeRepresenter do
  let(:display_name) { 'MyDisplayName' }
  let(:user) { create(:user, display_name: display_name) }
  let(:name) { 'Garlic bread' }
  let(:time_minutes) { 30 }
  let(:preface) { 'I was inspired by Peter Kay' }
  let(:recipe) { create(:recipe, user: user, name: name, time_minutes: time_minutes, preface: preface) }
  let(:amount) { '1 loaf' }
  let(:food) { 'Bread' }
  let(:preparation) { 'Sliced' }
  let(:optional) { true }
  let!(:ingredient) { create(:ingredient, recipe: recipe, amount: amount, food: food, preparation: preparation, optional: optional) }
  let(:position) { 4 }
  let(:instructions) { 'Spread garlic butter on bread' }
  let!(:step) { create(:step, recipe: recipe, position: position, instructions: instructions) }
  let(:tag_1_name) { 'Japanese' }
  let(:tag_1) { create(:tag, name: tag_1_name) }
  let!(:tag_1_recipe_tag) { create(:recipe_tag, recipe: recipe, tag: tag_1) }
  let(:tag_2_name) { 'Breakfast' }
  let(:tag_2) { create(:tag, name: tag_2_name) }
  let!(:tag_2_recipe_tag) { create(:recipe_tag, recipe: recipe, tag: tag_2) }
  describe 'as_json' do
    subject { RecipeRepresenter.new(recipe).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq({
        id: recipe.id,
        user: {
          id: user.id,
          display_name: display_name
        },
        name: name,
        time_minutes: time_minutes,
        preface: preface,
        ingredients: [
          {
            amount: amount,
            food: food,
            preparation: preparation,
            optional: optional
          }
        ],
        steps: [
          {
            position: position,
            instructions: instructions
          }
        ],
        tags: [
          {
            id: tag_1.id,
            name: tag_1_name
          },
          {
            id: tag_2.id,
            name: tag_2_name
          }
        ]
      })
    end
  end
end
