require 'rails_helper'

describe Tag, type: :model do
  subject { create(:tag) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'has many recipe tags' do
      let!(:recipe_tag) { create(:recipe_tag, tag: subject) }
      it { expect(subject.recipe_tags.first).to eq(recipe_tag) }

      describe 'dependent destroy' do
        it { expect { subject.destroy }.to change { RecipeTag.count }.by(-1) }
      end
    end

    describe 'has many recipes' do
      let(:recipe) { create(:recipe) }
      let!(:recipe_tag) { create(:recipe_tag, tag: subject, recipe: recipe) }
      it { expect(subject.recipes.first).to eq(recipe) }
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

      describe 'validates uniqueness of name' do
        # COMPLETE THIS
      end
    end
  end
end
