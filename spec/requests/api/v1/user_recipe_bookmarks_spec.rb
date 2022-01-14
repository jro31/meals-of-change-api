require 'rails_helper'

describe 'user_recipe_bookmarks API', type: :request do
  describe 'POST /api/v1/user_recipe_bookmarks' do
    let(:recipe) { create(:recipe) }
    let(:url) { '/api/v1/user_recipe_bookmarks' }
    let(:params) { { user_recipe_bookmark: { recipe_id: recipe.id } } }
    context 'user is logged-in' do
      include_context 'login'
      it 'creates a user recipe bookmark' do
        expect { post url, params: params }.to change { UserRecipeBookmark.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(
          {
            'user_recipe_bookmark' => {
              'id' => UserRecipeBookmark.last.id,
              'user_id' => current_user.id,
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
        let!(:existing_user_recipe_bookmark) { create(:user_recipe_bookmark, user: current_user, recipe: recipe) }
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

  describe 'GET /api/v1/bookmark_id' do
    let(:recipe) { create(:recipe) }
    let(:url) { '/api/v1/bookmark_id' }
    let(:params) { { recipe_id: recipe.id } }

    context 'user is logged-in' do
      include_context 'login'
      context 'user recipe bookmark exists' do
        let!(:user_recipe_bookmark) { create(:user_recipe_bookmark, user: current_user, recipe: recipe) }
        it 'returns the user recipe bookmark id' do
          get url, params: params

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({
            'bookmark_id' => user_recipe_bookmark.id
          })
        end
      end

      context 'user recipe bookmark does not exist' do
        it 'returns nil' do
          get url, params: params

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({
            'bookmark_id' => nil
          })
        end
      end
    end

    context 'user is not logged-in' do
      it 'returns unauthorized' do
        get url, params: params

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error_message' => 'not allowed to bookmark_id? this Class'
        })
      end
    end
  end

  describe 'DELETE /api/v1/user_recipe_bookmarks/:id' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }
    let!(:user_recipe_bookmark) { create(:user_recipe_bookmark, user: user, recipe: recipe) }
    let(:url) { "/api/v1/user_recipe_bookmarks/#{user_recipe_bookmark.id}" }
    context 'user is logged-in' do
      include_context 'login'
      context 'current user is the user recipe bookmark user' do
        let(:user) { current_user }
        it 'destroys the user recipe bookmark' do
          expect { delete url }.to change { UserRecipeBookmark.count }.by(-1)

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'current user is not the user recipe bookmark user' do
        it 'does not destroy the user recipe bookmark' do
          expect { delete url }.to change { UserRecipeBookmark.count }.by(0)

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq(
            {
              'error_message' => 'not allowed to destroy? this UserRecipeBookmark'
            }
          )
        end
      end
    end

    context 'user is not logged-in' do
      it 'does not destroy the user recipe bookmark' do
        expect { delete url }.to change { UserRecipeBookmark.count }.by(0)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq(
          {
            'error_message' => 'not allowed to destroy? this UserRecipeBookmark'
          }
        )
      end
    end
  end
end
