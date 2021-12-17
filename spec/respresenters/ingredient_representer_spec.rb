require 'rails_helper'

describe IngredientRepresenter do
  let(:amount) { '1 teaspoon' }
  let(:food) { 'Salt' }
  let(:preparation) { 'Crushed' }
  let(:optional) { true }
  let(:ingredient) { create(:ingredient, amount: amount, food: food, preparation: preparation, optional: optional) }
  describe 'as_json' do
    subject { IngredientRepresenter.new(ingredient).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq({
        amount: amount,
        food: food,
        preparation: preparation,
        optional: optional
      })
    end
  end
end
