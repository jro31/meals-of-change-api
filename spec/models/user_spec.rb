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
    end

    describe 'password' do
      subject { build(:user, password: password) }
      describe 'validates presence of password' do
        context 'password is present' do
          let(:password) { 'password' }
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
    end
  end
end
