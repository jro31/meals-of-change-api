require 'rails_helper'

describe 'recipes API', type: :request do
  describe 'GET /api/v1/recipes' do
    # TODO
    context 'ids_array=true param is passed-in' do
      # TODO
    end

    context 'user_id param is passed-in' do
      context 'user exists' do
        # TODO
      end

      context 'user does not exist' do
        # TODO
      end
    end

    context 'tag_id param is passed-in' do
      context 'tag exists' do
        # TODO
      end

      context 'tag does not exist' do
        # TODO
      end
    end

    context 'query param is passed-in' do
      # TODO
    end
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
            ],
            'photo' => recipe.photo_url
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
    let(:photo_blob_signed_id) { 'pH0t0_8108_51n63d_1D' }
    let(:photo_url) { 'www.photo-url.com' }
    let(:url) { '/api/v1/recipes' }
    let(:params) { { recipe: { name: name, time_minutes: time_minutes, preface: preface, ingredients_attributes: [toast, beans], steps_attributes: [step_1, step_2], tags: tags, photo_blob_signed_id: photo_blob_signed_id } } }
    before do
      allow_any_instance_of(Recipe).to receive_message_chain(:photo, :attach).and_return(true)
      allow_any_instance_of(Recipe).to receive(:photo_url).and_return(photo_url)
    end
    context 'user is logged-in' do
      let(:email) { 'user@email.com' }
      let(:password) { 'password' }
      let!(:user) { create(:user, email: email, password: password) }
      let(:expected_return) {
        {
          'recipe' => {
            'id' => Recipe.last.id,
            'user' => {
              'id' => user.id,
              'display_name' => user.display_name
            },
            'name' => name,
            'time_minutes' => time_minutes,
            'preface' => preface,
            'ingredients' => [
              {
                'amount' => toast[:amount],
                'food' => toast[:food],
                'preparation' => toast[:preparation],
                'optional' => toast[:optional]
              },
              {
                'amount' => beans[:amount],
                'food' => beans[:food],
                'preparation' => nil,
                'optional' => beans[:optional]
              }
            ],
            'steps' => [
              {
                'position' => step_1[:position],
                'instructions' => step_1[:instructions]
              },
              {
                'position' => step_2[:position],
                'instructions' => step_2[:instructions]
              }
            ],
            'tags' => expected_tag_return,
            'photo' => photo_url
          }
        }
      }
      before { post '/api/v1/sessions', params: { user: { email: email, password: password } } }
      context 'recipe has no tags' do
        let(:expected_tag_return) { [] }
        it 'creates a new recipe' do
          expect { post url, params: params }.to change { Recipe.count }.by(1)
                                             .and change { Ingredient.count }.by(2)
                                             .and change { Step.count }.by(2)
                                             .and change { Tag.count }.by(0)

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to eq(expected_return)
        end
      end

      context 'recipe has only new tags' do
        let(:new_tag_1) { 'New Tag 1' }
        let(:new_tag_2) { 'New Tag 2' }
        let(:tags) { [new_tag_1, new_tag_2] }
        let(:expected_tag_return) {
          [
            {
              'id' => Tag.first.id,
              'name' => new_tag_1.downcase
            },
            {
              'id' => Tag.last.id,
              'name' => new_tag_2.downcase
            }
          ]
        }
        it 'creates a new recipe' do
          expect { post url, params: params }.to change { Recipe.count }.by(1)
                                             .and change { Ingredient.count }.by(2)
                                             .and change { Step.count }.by(2)
                                             .and change { Tag.count }.by(2)

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to eq(expected_return)
        end
      end

      context 'recipe has only existing tags' do
        let!(:existing_tag_1) { create(:tag, name: 'existing tag 1') }
        let!(:existing_tag_2) { create(:tag, name: 'existing tag 2') }
        let(:tags) { [existing_tag_1.name, existing_tag_2.name] }
        let(:expected_tag_return) {
          [
            {
              'id' => existing_tag_1.id,
              'name' => existing_tag_1.name
            },
            {
              'id' => existing_tag_2.id,
              'name' => existing_tag_2.name
            }
          ]
        }
        it 'creates a new recipe' do
          expect { post url, params: params }.to change { Recipe.count }.by(1)
                                             .and change { Ingredient.count }.by(2)
                                             .and change { Step.count }.by(2)
                                             .and change { Tag.count }.by(0)

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to eq(expected_return)
        end
      end

      context 'recipe has new and existing tags' do
        let!(:existing_tag_1) { create(:tag, name: 'existing tag 1') }
        let!(:existing_tag_2) { create(:tag, name: 'existing tag 2') }
        let(:new_tag_1) { 'New Tag 1' }
        let(:new_tag_2) { 'New Tag 2' }
        let(:tags) { [existing_tag_1.name, new_tag_1, existing_tag_2.name, new_tag_2] }
        let(:expected_tag_return) {
          [
            {
              'id' => existing_tag_1.id,
              'name' => existing_tag_1.name
            },
            {
              'id' => existing_tag_2.id,
              'name' => existing_tag_2.name
            },
            {
              'id' => Tag.second_to_last.id,
              'name' => new_tag_1.downcase
            },
            {
              'id' => Tag.last.id,
              'name' => new_tag_2.downcase
            }
          ]
        }
        it 'creates a new recipe' do
          expect { post url, params: params }.to change { Recipe.count }.by(1)
                                             .and change { Ingredient.count }.by(2)
                                             .and change { Step.count }.by(2)
                                             .and change { Tag.count }.by(2)

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to eq(expected_return)
        end

        context 'recipe is invalid' do
          let(:name) { '' }
          it 'does not create a recipe' do
            expect { post url, params: params }.to change { Recipe.count }.by(0)
                                               .and change { Ingredient.count }.by(0)
                                               .and change { Step.count }.by(0)
                                               .and change { Tag.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
              'error_message' => 'Validation failed: Name can\'t be blank'
            })
          end
        end

        context 'an ingredient is invalid' do
          let(:beans) { { amount: '1 can', food: '', optional: true } }
          it 'does not create a recipe' do
            expect { post url, params: params }.to change { Recipe.count }.by(0)
                                               .and change { Ingredient.count }.by(0)
                                               .and change { Step.count }.by(0)
                                               .and change { Tag.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
              'error_message' => 'Validation failed: Ingredients food can\'t be blank'
            })
          end
        end

        context 'a step is invalid' do
          let(:step_1) { { position: 'one', instructions: 'Toast toast' } }
          it 'does not create a recipe' do
            expect { post url, params: params }.to change { Recipe.count }.by(0)
                                               .and change { Ingredient.count }.by(0)
                                               .and change { Step.count }.by(0)
                                               .and change { Tag.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
              'error_message' => 'Validation failed: Steps position is not a number'
            })
          end
        end

        context 'a tag is invalid' do
          let(:new_tag_1) { '' }
          let(:expected_tag_return) {
            [
              {
                'id' => existing_tag_1.id,
                'name' => existing_tag_1.name
              },
              {
                'id' => existing_tag_2.id,
                'name' => existing_tag_2.name
              },
              {
                'id' => Tag.last.id,
                'name' => new_tag_2.downcase
              }
            ]
          }
          it 'creates the recipe, omitting the invalid tag' do
            expect { post url, params: params }.to change { Recipe.count }.by(1)
                                                .and change { Ingredient.count }.by(2)
                                                .and change { Step.count }.by(2)
                                                .and change { Tag.count }.by(1)

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end

        context 'no photo blob signed id is passed-in' do
          let(:photo_blob_signed_id) { nil }
          let(:photo_url) { nil }
          it 'creates a new recipe' do
            expect { post url, params: params }.to change { Recipe.count }.by(1)
                                               .and change { Ingredient.count }.by(2)
                                               .and change { Step.count }.by(2)
                                               .and change { Tag.count }.by(2)

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end
      end
    end

    context 'user is not logged-in' do
      it 'does not create a recipe' do
        expect { post url, params: params }.to change { Recipe.count }.by(0)
                                           .and change { Ingredient.count }.by(0)
                                           .and change { Step.count }.by(0)
                                           .and change { Tag.count }.by(0)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error_message' => 'User must be signed-in to create a recipe'
        })
      end
    end
  end
end
