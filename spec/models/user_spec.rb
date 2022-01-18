require 'rails_helper'

describe User, type: :model do
  subject { create(:user) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'has many recipes' do
      let!(:recipe) { create(:recipe, user: subject) }
      it { expect(subject.recipes.first).to eq(recipe) }

      describe 'dependent destroy' do
        it { expect { subject.destroy }.to change { Recipe.count }.by(-1) }
      end
    end

    describe 'has many user recipe bookmarks' do
      let!(:user_recipe_bookmark) { create(:user_recipe_bookmark, user: subject) }
      it { expect(subject.user_recipe_bookmarks.first).to eq(user_recipe_bookmark) }

      describe 'dependent destroy' do
        it { expect { subject.destroy }.to change { UserRecipeBookmark.count }.by(-1) }
      end
    end

    describe 'has many bookmarked recipes' do
      let(:recipe) { create(:recipe) }
      let!(:user_recipe_bookmark) { create(:user_recipe_bookmark, user: subject, recipe: recipe) }
      it { expect(subject.bookmarked_recipes.first).to eq(recipe) }
    end
  end

  describe 'validations' do
    describe 'email' do
      let(:email) { 'test@email.com' }
      subject { build(:user, email: email) }
      it { expect(subject).to be_valid }
      describe 'validates presence of email' do
        context 'email is not present' do
          let(:email) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:email]).to include('can\'t be blank')
          end
        end
      end

      describe 'validates uniqueness of email' do
        let!(:other_user) { create(:user, email: other_user_email) }
        context 'email is unique' do
          let(:other_user_email) { 'unique@email.com' }
          it { expect(subject).to be_valid }
        end

        context 'email is not unique' do
          let(:other_user_email) { email }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:email]).to include('has already been taken')
          end
        end
      end

      describe 'validates format of email' do
        context 'email doesn\'t contain @' do
          let(:email) { 'testemail.com' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:email]).to include('is invalid')
          end
        end

        context 'email contains space' do
          let(:email) { 'te st@email.com' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:email]).to include('is invalid')
          end
        end

        context 'email doesn\'t contain anything after .' do
          let(:email) { 'testemail.' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:email]).to include('is invalid')
          end
        end

        context 'email doesn\'t contain anything before @' do
          let(:email) { '@email.com' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:email]).to include('is invalid')
          end
        end

        context 'email doesn\'t contain anything between @ and .' do
          let(:email) { 'test@.com' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:email]).to include('is invalid')
          end
        end
      end
    end

    describe 'password' do
      let(:password) { 'password' }
      subject { build(:user, password: password) }
      it { expect(subject).to be_valid }
      describe 'validates presence of password' do
        context 'password is not present' do
          let(:password) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:password]).to include('can\'t be blank')
          end
        end
      end

      describe 'validates length of password' do
        context 'password is 7 characters' do
          let(:password) { 'passwor' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:password]).to include('is too short (minimum is 8 characters)')
          end
        end

        context 'password is 8 characters' do
          let(:password) { 'password' }
          it { expect(subject).to be_valid }
        end
      end
    end

    describe 'display_name' do
      let(:display_name) { 'DisplayName' }
      subject { build(:user, display_name: display_name) }
      it { expect(subject).to be_valid }
      describe 'validates presence of display_name' do
        context 'display_name is not present' do
          let(:display_name) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:display_name]).to include('can\'t be blank')
          end
        end
      end

      describe 'validates uniqueness of display_name' do
        let!(:other_user) { create(:user, display_name: other_user_display_name) }
        context 'display_name is unique' do
          let(:other_user_display_name) { 'a-unique-name' }
          it { expect(subject).to be_valid }
        end

        context 'display_name is not unique' do
          let(:other_user_display_name) { display_name }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:display_name]).to include('has already been taken')
          end
        end
      end

      describe 'validates length of display_name' do
        context 'display_name is three characters' do
          let(:display_name) { 'abc' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:display_name]).to include('is too short (minimum is 4 characters)')
          end
        end

        context 'display_name is four characters' do
          let(:display_name) { 'abcd' }
          it { expect(subject).to be_valid }
        end

        context 'display_name is twenty characters' do
          let(:display_name) { 'abcdefghijklmnopqrst' }
          it { expect(subject).to be_valid }
        end

        context 'display_name is twenty-one characters' do
          let(:display_name) { 'abcdefghijklmnopqrstu' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:display_name]).to include('is too long (maximum is 20 characters)')
          end
        end
      end
    end

    describe 'twitter_handle' do
      let(:twitter_handle) { 'mealsofchange' }
      subject { build(:user, twitter_handle: twitter_handle) }
      it { expect(subject).to be_valid }
      describe 'validates length of twitter_handle' do
        context 'twitter_handle is nil' do
          let(:twitter_handle) { nil }
          it { expect(subject).to be_valid }
        end

        context 'twitter_handle is an empty string' do
          let(:twitter_handle) { '' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('is too short (minimum is 4 characters)')
          end
        end

        context 'twitter_handle is three characters' do
          let(:twitter_handle) { 'mea' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('is too short (minimum is 4 characters)')
          end
        end

        context 'twitter_handle is four characters' do
          let(:twitter_handle) { 'meal' }
          it { expect(subject).to be_valid }
        end

        context 'twitter_handle is fifteen characters' do
          let(:twitter_handle) { 'meals_of_change' }
          it { expect(subject).to be_valid }
        end

        context 'twitter_handle is sixteen characters' do
          let(:twitter_handle) { 'meals_of_changes' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('is too long (maximum is 15 characters)')
          end
        end
      end

      describe 'validates format of twitter_handle' do
        context 'contains capital letters' do
          let(:twitter_handle) { 'MealsOfChange' }
          it { expect(subject).to be_valid }
        end

        context 'contains lower-case letters' do
          it { expect(subject).to be_valid }
        end

        context 'contains numbers' do
          let(:twitter_handle) { 'm3a150fChan93' }
          it { expect(subject).to be_valid }
        end

        context 'contains underscores' do
          let(:twitter_handle) { 'meals_of_change' }
          it { expect(subject).to be_valid }
        end

        context 'contains spaces' do
          context 'at the beginning' do
            let(:twitter_handle) { ' meals' }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
            end
          end

          context 'in the middle' do
            let(:twitter_handle) { 'meals of change' }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
            end
          end

          context 'at the end' do
            let(:twitter_handle) { 'meals ' }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
            end
          end
        end

        context 'contains dashes' do
          let(:twitter_handle) { 'meals-of-change' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
          end
        end

        context 'contains full-stops' do
          let(:twitter_handle) { 'meals.of' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
          end
        end

        context 'contains @' do
          let(:twitter_handle) { '@meals' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
          end
        end

        context 'contains $' do
          let(:twitter_handle) { 'meal$' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
          end
        end

        context 'contains \'' do
          let(:twitter_handle) { "meal's" }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
          end
        end

        context 'contains "' do
          let(:twitter_handle) { '"meals' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
          end
        end

        context 'contains &' do
          let(:twitter_handle) { 'meals&of' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:twitter_handle]).to include('only allows letters, numbers and underscores')
          end
        end
      end
    end

    describe 'instagram_username' do
      let(:instagram_username) { 'mealsofchange' }
      subject { build(:user, instagram_username: instagram_username) }
      it { expect(subject).to be_valid }
      describe 'validates length of instagram_username' do
        context 'instagram_username is nil' do
          let(:instagram_username) { nil }
          it { expect(subject).to be_valid }
        end

        context 'instagram_username is an empty string' do
          let(:instagram_username) { '' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instagram_username]).to include('is too short (minimum is 1 character)')
          end
        end

        context 'instagram_username is thirty characters' do
          let(:instagram_username) { 'meals_of_changemeals_of_change' }
          it { expect(subject).to be_valid }
        end

        context 'instagram_username is thirty-one characters' do
          let(:instagram_username) { 'meals_of_changemeals_of_changes' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instagram_username]).to include('is too long (maximum is 30 characters)')
          end
        end
      end

      describe 'validates format of instagram_username' do
        context 'contains capital letters' do
          let(:instagram_username) { 'MealsOfChange' }
          it { expect(subject).to be_valid }
        end

        context 'contains lower-case letters' do
          it { expect(subject).to be_valid }
        end

        context 'contains numbers' do
          let(:instagram_username) { 'm3a150fChan93' }
          it { expect(subject).to be_valid }
        end

        context 'contains underscores' do
          let(:instagram_username) { 'meals_of_change' }
          it { expect(subject).to be_valid }
        end

        context 'contains spaces' do
          context 'at the beginning' do
            let(:instagram_username) { ' meals' }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
            end
          end

          context 'in the middle' do
            let(:instagram_username) { 'meals of change' }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
            end
          end

          context 'at the end' do
            let(:instagram_username) { 'meals ' }
            it 'is invalid with the correct error' do
              expect(subject).not_to be_valid
              expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
            end
          end
        end

        context 'contains dashes' do
          let(:instagram_username) { 'meals-of-change' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
          end
        end

        context 'contains full-stops' do
          let(:instagram_username) { 'meals.of' }
          it { expect(subject).to be_valid }
        end

        context 'contains @' do
          let(:instagram_username) { '@meals' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
          end
        end

        context 'contains $' do
          let(:instagram_username) { 'meal$' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
          end
        end

        context 'contains \'' do
          let(:instagram_username) { "meal's" }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
          end
        end

        context 'contains "' do
          let(:instagram_username) { '"meals' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
          end
        end

        context 'contains &' do
          let(:instagram_username) { 'meals&of' }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:instagram_username]).to include('only allows letters, numbers, full stops and underscores')
          end
        end
      end
    end
  end
end
