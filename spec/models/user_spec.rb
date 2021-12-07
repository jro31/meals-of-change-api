require 'rails_helper'

describe User, type: :model do
  subject { create(:user) }
  it { expect(subject).to be_valid }

  describe 'validations' do
    describe 'email' do
      let(:email) { 'test@email.com' }
      subject { build(:user, email: email) }
      describe 'validates presence of email' do
        context 'email is present' do
          it { expect(subject).to be_valid }
        end

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
        context 'email is valid' do
          it { expect(subject).to be_valid }
        end

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
      describe 'validates presence of password' do
        context 'password is present' do
          it { expect(subject).to be_valid }
        end

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
          it { expect(subject).to be_valid }
        end
      end
    end
  end
end
