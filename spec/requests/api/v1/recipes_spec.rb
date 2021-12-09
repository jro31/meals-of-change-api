require 'rails_helper'

describe 'recipes API', type: :request do
  describe 'GET /api/v1/recipes' do
    # COMPLETE THIS
  end

  describe 'GET /api/v1/recipes/:id' do
    let(:id) { 999 }
    let(:url) { "/api/v1/recipes/#{id}" }
    context 'recipe exists' do
      let(:id) { recipe.id }
      let(:user) { create(:user) }
      let(:recipe) { create(:recipe, user: user) }
      let!(:ingredient) { create(:ingredient, recipe: recipe) }
      let!(:step) { create(:step, recipe: recipe) }
      let(:tag) { create(:tag) }
      let!(:recipe_tag) { create(:recipe_tag, recipe: recipe, tag: tag) }
      it 'returns the recipe' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          'recipe' => {
            'id' => recipe.id,
            'user' => {
              'id' => user.id,
              'display_name' => user.display_name
            },
            'name' => recipe.name,
            'time_minutes' => recipe.time_minutes,
            'preface' => recipe.preface,
            'ingredients' => [
              {
                'amount' => ingredient.amount,
                'food' => ingredient.food,
                'preparation' => ingredient.preparation,
                'optional' => ingredient.optional
              }
            ],
            'steps' => [
              {
                'position' => step.position,
                'instructions' => step.instructions
              }
            ],
            'tags' => [
              {
                'id' => tag.id,
                'name' => tag.name
              }
            ]
          }
        })
      end
    end

    context 'recipe does not exist' do
      it 'returns a not found error' do
        get url

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({
          'error_message' => "Couldn't find Recipe with 'id'=#{id}"
        })
      end
    end
  end

  describe 'POST /api/v1/recipes' do
    context 'user is logged-in' do
      let(:email) { 'user@email.com' }
      let(:password) { 'password' }
      let!(:user) { create(:user, email: email, password: password) }
      before { post '/api/v1/sessions', params: { user: { email: email, password: password } } }
      # COMPLETE THIS
    end

    context 'user is not logged-in' do
      # COMPLETE THIS
    end
  end
end
