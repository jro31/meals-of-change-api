FactoryBot.define do
  factory :ingredient do
    recipe
    amount { '1 tablespoon' }
    food { 'Garlic' }
    preparation { 'Crushed' }
    optional { false }
  end
end
