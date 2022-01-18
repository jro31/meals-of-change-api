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
    let(:existing_password) { 'password' }
    let(:new_password) { 'new_password' }
    let(:new_display_name) { 'new_display_name' }
    let(:params_existing_password) { existing_password }
    let(:user) { create(:user, password: existing_password) }
    let(:url) { "/api/v1/accounts/#{user.id}" }
    let(:params) { { user: { existing_password: params_existing_password, password: new_password, password_confirmation: new_password, display_name: new_display_name } } }
    context 'user is signed-in' do
      include_context 'login'
      context 'supplied password matches param user password' do
        context 'param user matches current user' do
          let(:user) { current_user }
          context 'new password is included' do
            context 'new password confirmation is included' do
              context 'new password and new password confirmation match' do
                context 'new password is valid' do
                  context 'other new data is included' do
                    context 'other new data is valid' do
                      it 'updates all fields of user' do
                        expect(user.authenticate(existing_password)).to eq(user)
                        expect(user.authenticate(new_password)).to eq(false)
                        expect(user.display_name).not_to eq(new_display_name)

                        patch url, params: params

                        expect(user.authenticate(existing_password)).to eq(false)
                        expect(user.authenticate(new_password)).to eq(user)
                        expect(user.display_name).to eq(new_display_name)
                        expect(response).to have_http_status(:ok)
                        expect(JSON.parse(response.body)).to eq(
                          {
                            'user' => {
                              'id' => user.id,
                              'email' => user.email,
                              'display_name' => new_display_name
                            }
                          }
                        )
                      end
                    end

                    context 'other new data is not valid' do
                      # TODO
                    end
                  end

                  context 'new password is not valid' do
                    # TODO
                  end
                end

                context 'other new data is not included' do
                  # TODO
                end
              end

              context 'new password and new password confirmation don\'t match' do
                # TODO
              end
            end

            context 'new password confirmation is not included' do
              # TODO
            end
          end

          context 'new password is not included' do
            context 'other new data is valid' do
              # TODO
            end

            context 'other new data is not valid' do
              # TODO
            end
          end
        end

        context 'param user does not match current user' do
          # TODO
        end
      end

      context 'supplied password does not match param user password' do
        let(:params_existing_password) { 'wrong_password' }
        it 'returns unauthorized' do
          patch url, params: params

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq({
            'error_message' => 'Not authorized to update account'
          })
        end
      end
    end

    context 'user is not signed-in' do
      it 'returns unauthorized' do
        patch url, params: params

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error_message' => 'Not authorized to update account'
        })
      end
    end
  end
end
