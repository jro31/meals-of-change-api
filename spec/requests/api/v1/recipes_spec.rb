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
    let(:name) { 'Beans on toast' }
    let(:time_minutes) { 10 }
    let(:preface) { 'My inspiration for this recipe comes from eating beans on toast' }
    let(:toast) { { amount: '2 slices', food: 'bread', preparation: 'toasted', optional: false } }
    let(:beans) { { amount: '1 can', food: 'baked beans', optional: true } }
    let(:step_1) { { position: 1, instructions: 'Toast toast' } }
    let(:step_2) { { position: 2, instructions: 'Cook beans' } }
    let(:tags) { [] }
    let(:url) { '/api/v1/recipes' }
    let(:params) { { recipe: { name: name, time_minutes: time_minutes, preface: preface, ingredients_attributes: [toast, beans], steps_attributes: [step_1, step_2], tags: tags } } }
    context 'user is logged-in' do
      let(:email) { 'user@email.com' }
      let(:password) { 'password' }
      let!(:user) { create(:user, email: email, password: password) }
      before { post '/api/v1/sessions', params: { user: { email: email, password: password } } }
      context 'recipe has no tags' do
        it 'creates a new recipe' do
          expect { post url, params: params }.to change { Recipe.count }.by(1)
        end
      end

      context 'recipe has only new tags' do
        # COMPLETE THIS
      end

      context 'recipe has only existing tags' do
        # COMPLETE THIS
      end

      context 'recipe has new and existing tags' do
        # COMPLETE THIS
      end
    end

    context 'user is not logged-in' do
      # COMPLETE THIS
    end
  end
end
