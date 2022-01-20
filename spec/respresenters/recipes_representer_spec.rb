require 'rails_helper'

describe RecipesRepresenter do
  let(:display_name_1) { 'Dragon' }
  let(:twitter_handle_1) { 'fiery_monster' }
  let(:user_1) { create(:user, display_name: display_name_1, twitter_handle: twitter_handle_1) }
  let(:name_1) { 'Garlic bread' }
  let(:time_minutes_1) { 30 }
  let!(:recipe_1) { create(:recipe, user: user_1, name: name_1, time_minutes: time_minutes_1) }
  let(:display_name_2) { 'Brutus' }
  let(:instagram_username_2) { 'brutus_selfies' }
  let(:user_2) { create(:user, display_name: display_name_2, instagram_username: instagram_username_2) }
  let(:name_2) { 'Spaghetti' }
  let(:time_minutes_2) { 10 }
  let!(:recipe_2) { create(:recipe, user: user_2, name: name_2, time_minutes: time_minutes_2) }
  let(:photo_url) { 'www.photo-url.com' }
  before { allow_any_instance_of(Recipe).to receive(:small_photo_url).and_return(photo_url) }
  describe 'as_json' do
    subject { RecipesRepresenter.new(Recipe.all).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq(
        [
          {
            id: recipe_1.id,
            author: display_name_1,
            author_twitter_handle: twitter_handle_1,
            author_instagram_username: nil,
            name: name_1,
            time_minutes: time_minutes_1,
            small_photo: photo_url
          },
          {
            id: recipe_2.id,
            author: display_name_2,
            author_twitter_handle: nil,
            author_instagram_username: instagram_username_2,
            name: name_2,
            time_minutes: time_minutes_2,
            small_photo: photo_url
          }
        ]
      )
    end
  end
end
