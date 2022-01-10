FactoryBot.define do
  factory :tag do
    name { Faker::Alphanumeric.alphanumeric(number: 30) }
  end
end
