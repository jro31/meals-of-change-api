require 'rails_helper'

describe 'tags API', type: :request do
  let(:params) { '' }
  let(:url) { "/api/v1/tags?#{params}" }
  describe 'GET /api/v1/tags' do
    let(:noodles_recipe) { create(:recipe, name: 'Noodles') }
    let(:smoothie_recipe) { create(:recipe, name: 'Smoothie') }
    let(:somtum_recipe) { create(:recipe, name: 'Somtum') }
    let(:spaghetti_recipe) { create(:recipe, name: 'Spaghetti') }
    let(:thai_food_tag) { create(:tag, name: 'thai food') }
    let(:smoothie_tag) { create(:tag, name: 'smoothie') }
    let(:healthy_tag) { create(:tag, name: 'healthy') }
    let(:main_tag) { create(:tag, name: 'main') }
    context 'tags exist' do
      let!(:noodles_thai_food_recipe_tag) { create(:recipe_tag, recipe: noodles_recipe, tag: thai_food_tag) }
      let!(:noodles_healthy_recipe_tag) { create(:recipe_tag, recipe: noodles_recipe, tag: healthy_tag) }
      let!(:noodles_main_recipe_tag) { create(:recipe_tag, recipe: noodles_recipe, tag: main_tag) }
      let!(:smoothie_smoothie_recipe_tag) { create(:recipe_tag, recipe: smoothie_recipe, tag: smoothie_tag) }
      let!(:smoothie_healthy_recipe_tag) { create(:recipe_tag, recipe: smoothie_recipe, tag: healthy_tag) }
      let!(:somtum_thai_food_recipe_tag) { create(:recipe_tag, recipe: somtum_recipe, tag: thai_food_tag) }
      let!(:somtum_healthy_recipe_tag) { create(:recipe_tag, recipe: somtum_recipe, tag: healthy_tag) }
      let!(:somtum_main_recipe_tag) { create(:recipe_tag, recipe: somtum_recipe, tag: main_tag) }
      let!(:spaghetti_healthy_recipe_tag) { create(:recipe_tag, recipe: spaghetti_recipe, tag: healthy_tag) }
      let!(:spaghetti_main_recipe_tag) { create(:recipe_tag, recipe: spaghetti_recipe, tag: main_tag) }
      it 'returns the tags' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          'tags' => [
            'healthy', 'main', 'thai food', 'smoothie'
          ]
        })
      end

      context 'limit param is passed-in' do
        let(:params) { 'limit=2' }
        it 'returns the two most-used tags' do
          get url

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({
            'tags' => [
              'healthy', 'main'
            ]
          })
        end
      end
    end

    context 'no tags exist' do
      it 'returns an empty array' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          'tags' => []
        })
      end
    end
  end
end
