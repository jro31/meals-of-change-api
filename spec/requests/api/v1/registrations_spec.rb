require 'rails_helper'

describe 'registrations API', type: :request do
  describe 'POST /api/v1/registrations' do
    let(:email) { 'newuser@email.com' }
    let(:password) { 'password' }
    let(:password_confirmation) { password }
    let(:url) { '/api/v1/registrations' }
    let(:params) { { user: { email: email, password: password, password_confirmation: password_confirmation } } }
    context 'user is valid' do
      it 'creates a new user' do
        expect { post url, params: params }.to change { User.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['logged_in']).to eq(true)
        expect(JSON.parse(response.body)['user']['email']).to eq(email)
      end
    end

    context 'email address already exists' do
      let!(:existing_user) { create(:user, email: email) }
      it 'does not create a new user' do
        expect { post url, params: params }.to change { User.count }.by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error_message']).to eq('Email has already been taken')
      end
    end

    context 'email address is invalid' do
      let(:email) { 'invalidemail.com' }
      it 'does not create a new user' do
        expect { post url, params: params }.to change { User.count }.by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error_message']).to eq('Email is invalid')
      end
    end

    context 'email param is not included' do
      let(:params) { { user: { password: password, password_confirmation: password } } }
      it 'does not create a new user' do
        expect { post url, params: params }.to change { User.count }.by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error_message']).to include('Email can\'t be blank')
      end
    end

    context 'password is too short' do
      let(:password) { 'passwor' }
      it 'does not create a new user' do
        expect { post url, params: params }.to change { User.count }.by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error_message']).to eq('Password is too short (minimum is 8 characters)')
      end
    end

    context 'password param is not included' do
      let(:params) { { user: { email: email, password_confirmation: password } } }
      it 'does not create a new user' do
        expect { post url, params: params }.to change { User.count }.by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error_message']).to include('Password can\'t be blank')
      end
    end

    context 'password confirmation doesn\'t match password' do
      let(:password_confirmation) { 'wrong_password' }
      it 'does not create a new user' do
        expect { post url, params: params }.to change { User.count }.by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error_message']).to eq('Password confirmation doesn\'t match Password')
      end
    end

    context 'password confirmation param is not included' do
      let(:params) { { user: { email: email, password: password } } }
      it 'does not create a new user' do
        expect { post url, params: params }.to change { User.count }.by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error_message']).to eq('Password confirmation not included')
      end
    end
  end
end
