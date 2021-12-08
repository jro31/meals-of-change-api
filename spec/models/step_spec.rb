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
    describe 'position' do
      let(:position) { 1 }
      subject { build(:step, position: position) }
      it { expect(subject).to be_valid }
      describe 'validates presence of position' do
        context 'position is not present' do
          let(:position) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:position]).to include('can\'t be blank')
          end
        end
      end

      describe 'validates uniqueness of position' do
        let!(:other_step) { create(:step, position: other_step_position) }
        context 'position is unique' do
          let(:other_step_position) { position + 1 }
          it { expect(subject).to be_valid }
        end

        context 'position is not unique' do
          let(:other_step_position) { position }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:position]).to include('has already been taken')
          end
        end
      end

      describe 'validates numericality of position' do
        describe 'only integer' do
          context 'position is a decimal' do
            let(:position) { 1.0 }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:position]).to include('must be an integer')
            end
          end
        end

        describe 'greater than or equal to 1' do
          context 'position is 0' do
            let(:position) { 0 }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:position]).to include('must be greater than or equal to 1')
            end
          end

          context 'position is -1' do
            let(:position) { -1 }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:position]).to include('must be greater than or equal to 1')
            end
          end
        end
      end
    end

    describe 'instructions' do
      let(:instructions) { 'Some recipe instructions' }
      subject { build(:step, instructions: instructions) }
      it { expect(subject).to be_valid }
      describe 'validates presence of instructions' do
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
