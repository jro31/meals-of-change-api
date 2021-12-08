require 'rails_helper'

describe RecipeTag, type: :model do
  subject { create(:recipe_tag) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'belongs to recipe' do
      # COMPLETE THIS
    end

    describe 'belongs to tag' do
      # COMPLETE THIS
    end
  end
end
