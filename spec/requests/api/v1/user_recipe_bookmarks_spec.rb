require 'rails_helper'

describe 'user_recipe_bookmarks API', type: :request do
  describe 'POST /api/v1/user_recipe_bookmarks' do
    let(:recipe) { create(:recipe) }
    let(:url) { '/api/v1/user_recipe_bookmarks' }
    let(:params) { { user_recipe_bookmark: { recipe_id: recipe.id } } }
    context 'user is logged-in' do
      let(:email) { 'user@email.com' }
      let(:password) { 'password' }
      let!(:user) { create(:user, email: email, password: password) }
      before { post '/api/v1/sessions', params: { user: { email: email, password: password } } }
      it 'creates a user recipe bookmark' do
        expect { post url, params: params }.to change { UserRecipeBookmark.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(
          {
            'user_recipe_bookmark' => {
              'id' => UserRecipeBookmark.last.id,
              'user_id' => user.id,
              'recipe_id' => recipe.id
            }
          }
        )
      end

      context 'user_recipe_bookmark param is empty' do
        let(:params) { { user_recipe_bookmark: {} } }
        it 'does not create a user recipe bookmark' do
          expect { post url, params: params }.to change { UserRecipeBookmark.count }.by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq(
            {
              'error_message' => 'param is missing or the value is empty: user_recipe_bookmark'
            }
          )
        end
      end

      context 'recipe_id is not passed in the params' do
        let(:params) { { user_recipe_bookmark: { something_random: '' } } }
        it 'does not create a user recipe bookmark' do
          expect { post url, params: params }.to change { UserRecipeBookmark.count }.by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq(
            {
              'error_message' => 'Validation failed: Recipe must exist'
            }
          )
        end
      end

      context 'recipe_id is nil' do
        let(:params) { { user_recipe_bookmark: { recipe_id: nil } } }
        it 'does not create a user recipe bookmark' do
          expect { post url, params: params }.to change { UserRecipeBookmark.count }.by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq(
            {
              'error_message' => 'Validation failed: Recipe must exist'
            }
          )
        end
      end

      context 'recipe does not exist for passed-in ID' do
        let(:params) { { user_recipe_bookmark: { recipe_id: 999 } } }
        it 'does not create a user recipe bookmark' do
          expect { post url, params: params }.to change { UserRecipeBookmark.count }.by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq(
            {
              'error_message' => 'Validation failed: Recipe must exist'
            }
          )
        end
      end

      context 'association already exists' do
        let!(:existing_user_recipe_bookmark) { create(:user_recipe_bookmark, user: user, recipe: recipe) }
        it 'does not create a user recipe bookmark' do
          expect { post url, params: params }.to change { UserRecipeBookmark.count }.by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq(
            {
              'error_message' => 'Validation failed: User has already favourited this recipe'
            }
          )
        end
      end
    end

    context 'user is not logged-in' do
      it 'does not create a user recipe bookmark' do
        expect { post url, params: params }.to change { UserRecipeBookmark.count }.by(0)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq(
          {
            'error_message' => 'User must be signed-in to bookmark a recipe'
          }
        )
      end
    end
  end

  describe 'DELETE /api/v1/user_recipe_bookmarks/:id' do
    # TODO
  end
end
