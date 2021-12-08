require 'rails_helper'

describe Recipe, type: :model do
  subject { create(:recipe) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'belongs to user' do
      let(:user) { create(:user) }
      subject { create(:recipe, user: user) }
      it { expect(subject.user).to eq(user) }
    end
  end
end
