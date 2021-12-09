require 'rails_helper'

describe UserRepresenter do
  let(:email) { 'test@email.com' }
  let(:display_name) { 'DisplayName' }
  let(:user) { create(:user, email: email, display_name: display_name) }
  describe 'as_json' do
    subject { UserRepresenter.new(user).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq({
        id: user.id,
        email: email,
        display_name: display_name
      })
    end

    context 'include_email is false' do
      subject { UserRepresenter.new(user, false).as_json }
      it 'returns the correct hash' do
        expect(subject).to eq({
          id: user.id,
          display_name: display_name
        })
      end
    end
  end
end
