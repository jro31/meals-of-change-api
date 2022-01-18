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
        display_name: display_name,
        twitter_handle: nil,
        instagram_username: nil
      })
    end

    context 'include_email is false' do
      subject { UserRepresenter.new(user, false).as_json }
      it 'returns the correct hash' do
        expect(subject).to eq({
          id: user.id,
          display_name: display_name,
          twitter_handle: nil,
          instagram_username: nil
        })
      end
    end

    context 'twitter_handle and instagram_username exist' do
      let(:user) { create(:user, email: email, display_name: display_name, twitter_handle: 'mealsofchange', instagram_username: 'meals_of_change') }
      it 'returns the correct hash' do
        expect(subject).to eq({
          id: user.id,
          email: email,
          display_name: display_name,
          twitter_handle: 'mealsofchange',
          instagram_username: 'meals_of_change'
        })
      end
    end
  end
end
