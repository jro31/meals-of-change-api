require 'rails_helper'

describe 'sessions API', type: :request do
  let(:email) { 'user@email.com' }
  let(:password) { 'password' }
  let!(:user) { create(:user, email: email, password: password) }
  describe 'POST /api/v1/sessions' do
    let(:url) { '/api/v1/sessions' }
    let(:params) { { user: { email: email, password: password } } }
    context 'user exists' do
      context 'password is correct' do
        it 'logs-in the user' do
          post url, params: params

          expect(response).to have_http_status(:created)
          expect(session[:user_id]).to eq(user.id)
          expect(JSON.parse(response.body)['logged_in']).to eq(true)
          expect(JSON.parse(response.body)['user']['email']).to eq(email)
        end
      end

      context 'password is not correct' do
        let(:params) { { user: { email: email, password: 'wrong_password' } } }
        it 'does not login the user' do
          post url, params: params

          expect(response).to have_http_status(:unauthorized)
          expect(session[:user_id]).to eq(nil)
          expect(JSON.parse(response.body)['error_message']).to eq('Incorrect username/password')
        end
      end
    end

    context 'user does not exist' do
      let!(:user) { nil }
      it 'returns unauthorized' do
        post url, params: params

        expect(response).to have_http_status(:unauthorized)
        expect(session[:user_id]).to eq(nil)
        expect(JSON.parse(response.body)['error_message']).to eq('Incorrect username/password')
      end
    end
  end

  describe 'GET /api/v1/logged_in' do
    let(:url) { '/api/v1/logged_in' }
    context 'user is logged-in' do
      before { post '/api/v1/sessions', params: { user: { email: email, password: password } } }
      it 'returns the logged-in user' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['logged_in']).to eq(true)
        expect(JSON.parse(response.body)['user']['email']).to eq(email)
      end
    end

    context 'user is not logged-in' do
      it 'returns logged-in false' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['logged_in']).to eq(false)
        expect(JSON.parse(response.body)['user']).to eq(nil)
      end
    end
  end

  describe 'DELETE /api/v1/logout' do
    let(:url) { '/api/v1/logout' }
    context 'user is logged-in' do
      before { post '/api/v1/sessions', params: { user: { email: email, password: password } } }
      it 'logs-out the user' do
        expect(session[:user_id]).to eq(user.id)

        delete url

        expect(response).to have_http_status(:ok)
        expect(session[:user_id]).to eq(nil)
        expect(JSON.parse(response.body)['logged_out']).to eq(true)
      end
    end
  end
end
