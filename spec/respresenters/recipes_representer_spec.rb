require 'rails_helper'

describe RecipesRepresenter do
  let(:display_name_1) { 'Dragon' }
  let(:user_1) { create(:user, display_name: display_name_1) }
  let(:name_1) { 'Garlic bread' }
  let(:time_minutes_1) { 30 }
  let!(:recipe_1) { create(:recipe, user: user_1, name: name_1, time_minutes: time_minutes_1) }
  let(:display_name_2) { 'Brutus' }
  let(:user_2) { create(:user, display_name: display_name_2) }
  let(:name_2) { 'Spaghetti' }
  let(:time_minutes_2) { 10 }
  let!(:recipe_2) { create(:recipe, user: user_2, name: name_2, time_minutes: time_minutes_2) }
  let(:photo_url) { 'www.photo-url.com' }
  before { allow_any_instance_of(Recipe).to receive(:photo_url).and_return(photo_url) }
  describe 'as_json' do
    subject { RecipesRepresenter.new(Recipe.all).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq(
        [
          {
            id: recipe_2.id,
            author: display_name_2,
            name: name_2,
            time_minutes: time_minutes_2,
            photo: photo_url
          },
          {
            id: recipe_1.id,
            author: display_name_1,
            name: name_1,
            time_minutes: time_minutes_1,
            photo: photo_url
          }
        ]
      )
    end
  end
end
