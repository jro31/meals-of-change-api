require 'rails_helper'

describe StaticController, type: :controller do
  describe 'GET home' do
    it 'returns a success message' do
      get 'home'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq('status' => 'It\'s working')
    end
  end
end
