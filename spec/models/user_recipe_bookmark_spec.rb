require 'rails_helper'

describe UserRecipeBookmark, type: :model do
  subject { create(:user_recipe_bookmark) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'belongs to user' do
      # TODO
    end

    describe 'belongs to recipe' do
      # TODO
    end
  end
end
