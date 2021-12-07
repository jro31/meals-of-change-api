FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    display_name { Faker::Internet.username(specifier: 4..20) }
  end
end
