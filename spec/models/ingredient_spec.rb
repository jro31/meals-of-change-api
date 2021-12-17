require 'rails_helper'

describe Ingredient, type: :model do
  subject { create(:ingredient) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'belongs to recipe' do
      let(:recipe) { create(:recipe) }
      subject { create(:ingredient, recipe: recipe) }
      it { expect(subject.recipe).to eq(recipe) }
    end
  end

  describe 'validations' do
    describe 'food' do
      let(:food) { 'Garlic' }
      subject { build(:ingredient, food: food) }
      it { expect(subject).to be_valid }
      describe 'validates presence of food' do
        context 'food is not present' do
          let(:food) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:food]).to include('can\'t be blank')
          end
        end
      end
    end
  end
end
