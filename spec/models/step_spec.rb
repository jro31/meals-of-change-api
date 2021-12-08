require 'rails_helper'

describe Step, type: :model do
  subject { create(:step) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'belongs to recipe' do
      let(:recipe) { create(:recipe) }
      subject { create(:step, recipe: recipe) }
      it { expect(subject.recipe).to eq(recipe) }
    end
  end

  describe 'validations' do
    describe 'instructions' do
      let(:instructions) { 'Some recipe instructions' }
      subject { build(:step, instructions: instructions) }
      describe 'validates presence of instructions' do
        context 'instructions is present' do
          it { expect(subject).to be_valid }
        end

        context 'instructions is not present' do
          let(:instructions) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instructions]).to include('can\'t be blank')
          end
        end
      end
    end
  end
end
