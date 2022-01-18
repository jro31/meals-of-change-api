require 'rails_helper'

describe 'accounts API', type: :request do
  describe 'GET /api/v1/account' do
    let(:url) { '/api/v1/account' }
    context 'user is signed-in' do
      include_context 'login'
      it 'returns the user' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(
          {
            'user' => {
              'id' => current_user.id,
              'email' => current_user.email,
              'display_name' => current_user.display_name
            }
          }
        )
      end
    end

    context 'user is not signed-in' do
      it 'returns unauthorized' do
        get url

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error_message' => 'User must be logged-in to access account'
        })
      end
    end
  end

  describe 'PATCH /api/v1/accounts/:id' do
    # TODO
  end
end
