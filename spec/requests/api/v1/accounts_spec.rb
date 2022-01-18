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
              'display_name' => current_user.display_name,
              'twitter_handle' => current_user.twitter_handle,
              'instagram_username' => current_user.instagram_username
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
    let(:twitter_handle) { 'mealsofchange' }
    let(:instagram_username) { 'meals_of_change' }
    let(:params_existing_password) { existing_password }
    let(:user) { create(:user, password: existing_password) }
    let(:url) { "/api/v1/accounts/#{user.id}" }
    let(:params) { { user: { existing_password: params_existing_password, password: new_password, password_confirmation: new_password, display_name: new_display_name, twitter_handle: twitter_handle, instagram_username: instagram_username } } }
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
                        expect(user.twitter_handle).to eq(nil)
                        expect(user.instagram_username).to eq(nil)

                        patch url, params: params

                        user.reload
                        expect(user.authenticate(existing_password)).to eq(false)
                        expect(user.authenticate(new_password)).to eq(user)
                        expect(response).to have_http_status(:ok)
                        expect(JSON.parse(response.body)).to eq(
                          {
                            'user' => {
                              'id' => user.id,
                              'email' => user.email,
                              'display_name' => new_display_name,
                              'twitter_handle' => twitter_handle,
                              'instagram_username' => instagram_username
                            }
                          }
                        )
                      end

                      context 'twitter_handle and instagram_username already exist' do
                        before { user.update(twitter_handle: 'my_handle', instagram_username: 'my_username') }
                        context 'both are updated' do
                          it 'updates all fields of user' do
                            expect(user.authenticate(existing_password)).to eq(user)
                            expect(user.authenticate(new_password)).to eq(false)
                            expect(user.display_name).not_to eq(new_display_name)
                            expect(user.twitter_handle).to eq('my_handle')
                            expect(user.instagram_username).to eq('my_username')

                            patch url, params: params

                            user.reload
                            expect(user.authenticate(existing_password)).to eq(false)
                            expect(user.authenticate(new_password)).to eq(user)
                            expect(response).to have_http_status(:ok)
                            expect(JSON.parse(response.body)).to eq(
                              {
                                'user' => {
                                  'id' => user.id,
                                  'email' => user.email,
                                  'display_name' => new_display_name,
                                  'twitter_handle' => twitter_handle,
                                  'instagram_username' => instagram_username
                                }
                              }
                            )
                          end
                        end

                        context 'twitter_handle is updated' do
                          let(:params) { { user: { existing_password: params_existing_password, password: new_password, password_confirmation: new_password, display_name: new_display_name, twitter_handle: twitter_handle } } }
                          it 'doesn\'t change instagram_username' do
                            expect(user.authenticate(existing_password)).to eq(user)
                            expect(user.authenticate(new_password)).to eq(false)
                            expect(user.display_name).not_to eq(new_display_name)
                            expect(user.twitter_handle).to eq('my_handle')
                            expect(user.instagram_username).to eq('my_username')

                            patch url, params: params

                            user.reload
                            expect(user.authenticate(existing_password)).to eq(false)
                            expect(user.authenticate(new_password)).to eq(user)
                            expect(response).to have_http_status(:ok)
                            expect(JSON.parse(response.body)).to eq(
                              {
                                'user' => {
                                  'id' => user.id,
                                  'email' => user.email,
                                  'display_name' => new_display_name,
                                  'twitter_handle' => twitter_handle,
                                  'instagram_username' => 'my_username'
                                }
                              }
                            )
                          end
                        end

                        context 'instagram_username is updated' do
                          let(:params) { { user: { existing_password: params_existing_password, password: new_password, password_confirmation: new_password, display_name: new_display_name, instagram_username: instagram_username } } }
                          it 'doesn\'t change twitter_handle' do
                            expect(user.authenticate(existing_password)).to eq(user)
                            expect(user.authenticate(new_password)).to eq(false)
                            expect(user.display_name).not_to eq(new_display_name)
                            expect(user.twitter_handle).to eq('my_handle')
                            expect(user.instagram_username).to eq('my_username')

                            patch url, params: params

                            user.reload
                            expect(user.authenticate(existing_password)).to eq(false)
                            expect(user.authenticate(new_password)).to eq(user)
                            expect(response).to have_http_status(:ok)
                            expect(JSON.parse(response.body)).to eq(
                              {
                                'user' => {
                                  'id' => user.id,
                                  'email' => user.email,
                                  'display_name' => new_display_name,
                                  'twitter_handle' => 'my_handle',
                                  'instagram_username' => instagram_username
                                }
                              }
                            )
                          end
                        end

                        context 'neither are updated' do
                          let(:params) { { user: { existing_password: params_existing_password, password: new_password, password_confirmation: new_password, display_name: new_display_name } } }
                          it 'doesn\'t change twitter_handle or instagram_username' do
                            expect(user.authenticate(existing_password)).to eq(user)
                            expect(user.authenticate(new_password)).to eq(false)
                            expect(user.display_name).not_to eq(new_display_name)
                            expect(user.twitter_handle).to eq('my_handle')
                            expect(user.instagram_username).to eq('my_username')

                            patch url, params: params

                            user.reload
                            expect(user.authenticate(existing_password)).to eq(false)
                            expect(user.authenticate(new_password)).to eq(user)
                            expect(response).to have_http_status(:ok)
                            expect(JSON.parse(response.body)).to eq(
                              {
                                'user' => {
                                  'id' => user.id,
                                  'email' => user.email,
                                  'display_name' => new_display_name,
                                  'twitter_handle' => 'my_handle',
                                  'instagram_username' => 'my_username'
                                }
                              }
                            )
                          end
                        end
                      end

                      context 'display_name is not updated' do
                        let(:params) { { user: { existing_password: params_existing_password, password: new_password, password_confirmation: new_password, twitter_handle: twitter_handle, instagram_username: instagram_username } } }
                        it 'doesn\'t update display_name' do
                          expect(user.authenticate(existing_password)).to eq(user)
                          expect(user.authenticate(new_password)).to eq(false)
                          expect(user.display_name).not_to eq(new_display_name)
                          expect(user.twitter_handle).to eq(nil)
                          expect(user.instagram_username).to eq(nil)

                          patch url, params: params

                          user.reload
                          expect(user.authenticate(existing_password)).to eq(false)
                          expect(user.authenticate(new_password)).to eq(user)
                          expect(user.display_name).not_to eq(new_display_name)
                          expect(response).to have_http_status(:ok)
                          expect(JSON.parse(response.body)).to eq(
                            {
                              'user' => {
                                'id' => user.id,
                                'email' => user.email,
                                'display_name' => user.display_name,
                                'twitter_handle' => twitter_handle,
                                'instagram_username' => instagram_username
                              }
                            }
                          )
                        end
                      end
                    end

                    context 'other new data is not valid' do
                      context 'display_name' do
                        let(:new_display_name) { 'twenty-one-characters' }
                        it 'does not update user' do
                          patch url, params: params

                          expect(response).to have_http_status(:unprocessable_entity)
                          expect(JSON.parse(response.body)).to eq({
                            'error_message' => 'Validation failed: Display name is too long (maximum is 20 characters)'
                          })
                        end
                      end

                      context 'twitter_handle' do
                        let(:twitter_handle) { 'contains space' }
                        it 'does not update user' do
                          patch url, params: params

                          expect(response).to have_http_status(:unprocessable_entity)
                          expect(JSON.parse(response.body)).to eq({
                            'error_message' => 'Validation failed: Twitter handle only allows letters, numbers and underscores'
                          })
                        end
                      end

                      context 'instagram_username' do
                        let(:instagram_username) { 'has_ampersand&' }
                        it 'does not update user' do
                          patch url, params: params

                          expect(response).to have_http_status(:unprocessable_entity)
                          expect(JSON.parse(response.body)).to eq({
                            'error_message' => 'Validation failed: Instagram username only allows letters, numbers, full stops and underscores'
                          })
                        end
                      end
                    end
                  end

                  context 'other new data is not included' do
                    let(:params) { { user: { existing_password: params_existing_password, password: new_password, password_confirmation: new_password } } }
                    it 'updates just the password' do
                      expect(user.authenticate(existing_password)).to eq(user)
                      expect(user.authenticate(new_password)).to eq(false)

                      patch url, params: params

                      user.reload
                      expect(user.authenticate(existing_password)).to eq(false)
                      expect(user.authenticate(new_password)).to eq(user)
                      expect(response).to have_http_status(:ok)
                      expect(JSON.parse(response.body)).to eq(
                        {
                          'user' => {
                            'id' => user.id,
                            'email' => user.email,
                            'display_name' => user.display_name,
                            'twitter_handle' => nil,
                            'instagram_username' => nil
                          }
                        }
                      )
                    end
                  end
                end

                context 'new password is not valid' do
                  let(:new_password) { '_seven_' }
                  it 'does not update user' do
                    patch url, params: params

                    expect(response).to have_http_status(:unprocessable_entity)
                    expect(JSON.parse(response.body)).to eq({
                      'error_message' => 'Validation failed: Password is too short (minimum is 8 characters)'
                    })
                  end
                end
              end

              context 'new password and new password confirmation don\'t match' do
                let(:params) { { user: { existing_password: params_existing_password, password: new_password, password_confirmation: 'wrong_password', display_name: new_display_name, twitter_handle: twitter_handle, instagram_username: instagram_username } } }
                it 'does not update user' do
                  patch url, params: params

                  expect(response).to have_http_status(:unprocessable_entity)
                  expect(JSON.parse(response.body)).to eq({
                    'error_message' => 'Validation failed: Password confirmation doesn\'t match Password'
                  })
                end
              end
            end

            context 'new password confirmation is not included' do
              let(:params) { { user: { existing_password: params_existing_password, password: new_password, display_name: new_display_name, twitter_handle: twitter_handle, instagram_username: instagram_username } } }
              it 'does not update user' do
                patch url, params: params

                expect(response).to have_http_status(:unprocessable_entity)
                expect(JSON.parse(response.body)).to eq({
                  'error_message' => 'Password confirmation not included'
                })
              end
            end
          end

          context 'new password is not included' do
            context 'password_confirmation is included' do
              let(:params) { { user: { existing_password: params_existing_password, password_confirmation: new_password, display_name: new_display_name, twitter_handle: twitter_handle, instagram_username: instagram_username } } }
              it 'does not update user' do
                patch url, params: params

                expect(response).to have_http_status(:unprocessable_entity)
                expect(JSON.parse(response.body)).to eq({
                  'error_message' => 'New password not included'
                })
              end
            end

            context 'other new data is valid' do
              let(:params) { { user: { existing_password: params_existing_password, display_name: new_display_name, twitter_handle: twitter_handle, instagram_username: instagram_username } } }
              it 'updates the other fields of user' do
                expect(user.display_name).not_to eq(new_display_name)
                expect(user.twitter_handle).to eq(nil)
                expect(user.instagram_username).to eq(nil)

                patch url, params: params

                user.reload
                expect(user.authenticate(existing_password)).to eq(user)
                expect(user.authenticate(new_password)).to eq(false)
                expect(response).to have_http_status(:ok)
                expect(JSON.parse(response.body)).to eq(
                  {
                    'user' => {
                      'id' => user.id,
                      'email' => user.email,
                      'display_name' => new_display_name,
                      'twitter_handle' => twitter_handle,
                      'instagram_username' => instagram_username
                    }
                  }
                )
              end
            end

            context 'other new data is not valid' do
              context 'display_name' do
                let(:new_display_name) { 'twenty-one-characters' }
                it 'does not update user' do
                  patch url, params: params

                  expect(response).to have_http_status(:unprocessable_entity)
                  expect(JSON.parse(response.body)).to eq({
                    'error_message' => 'Validation failed: Display name is too long (maximum is 20 characters)'
                  })
                end
              end
            end
          end
        end

        context 'param user does not match current user' do
          it 'does not update user' do
            patch url, params: params

            expect(response).to have_http_status(:unauthorized)
            expect(JSON.parse(response.body)).to eq({
              'error_message' => 'Not authorized to update account'
            })
          end
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

      context 'existing password is not supplied' do
        let(:params) { { user: { password: new_password, password_confirmation: new_password, display_name: new_display_name, twitter_handle: twitter_handle, instagram_username: instagram_username } } }
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
