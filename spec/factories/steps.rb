FactoryBot.define do
  factory :step do
    recipe
    position { 1 }
    instructions { 'Put the food in the oven' }
  end
end
