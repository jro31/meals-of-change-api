require 'rails_helper'

describe Tag, type: :model do
  subject { create(:tag) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'has many recipe tags' do
      # COMPLETE THIS

      describe 'dependent destroy' do
        # COMPLETE THIS
      end
    end

    describe 'has many recipes' do
      # COMPLETE THIS
    end
  end

  describe 'validations' do
    describe 'name' do
      let(:name) { 'Thai food' }
      subject { build(:tag, name: name) }
      it { expect(subject).to be_valid }
      describe 'validates presence of name' do
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
end
