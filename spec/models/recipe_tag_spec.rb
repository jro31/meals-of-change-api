require 'rails_helper'

describe RecipeTag, type: :model do
  subject { create(:recipe_tag) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'belongs to recipe' do
      let(:recipe) { create(:recipe) }
      subject { create(:recipe_tag, recipe: recipe) }
      it { expect(subject.recipe).to eq(recipe) }
    end

    describe 'belongs to tag' do
      let(:tag) { create(:tag) }
      subject { create(:recipe_tag, tag: tag) }
      it { expect(subject.tag).to eq(tag) }
    end
  end
end
