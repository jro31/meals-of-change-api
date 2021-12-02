require 'rails_helper'

describe User, type: :model do
  subject { create(:user) }
  it { expect(subject).to be_valid }
end
