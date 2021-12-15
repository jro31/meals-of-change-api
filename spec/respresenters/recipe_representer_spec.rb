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
  let(:step_3_position) { 4 }
  let(:step_3_instructions) { 'Eat garlic bread' }
  let!(:step_3) { create(:step, recipe: recipe, position: step_3_position, instructions: step_3_instructions) }
  let(:step_1_position) { 1 }
  let(:step_1_instructions) { 'Make bread' }
  let!(:step_1) { create(:step, recipe: recipe, position: step_1_position, instructions: step_1_instructions) }
  let(:step_2_position) { 2 }
  let(:step_2_instructions) { 'Spread garlic butter on bread' }
  let!(:step_2) { create(:step, recipe: recipe, position: step_2_position, instructions: step_2_instructions) }
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
            position: step_1_position,
            instructions: step_1_instructions
          },
          {
            position: step_2_position,
            instructions: step_2_instructions
          },
          {
            position: step_3_position,
            instructions: step_3_instructions
          }
        ],
        tags: [
          {
            id: tag_2.id,
            name: tag_2_name
          },
          {
            id: tag_1.id,
            name: tag_1_name
          }
        ],
        photo: nil
      })
    end
  end
end
