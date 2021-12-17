FactoryBot.define do
  factory :step do
    recipe
    position { recipe.steps.any? ? recipe.steps.order(position: :asc).last.position + 1 : 1 }
    instructions { 'Put the food in the oven' }
  end
end
