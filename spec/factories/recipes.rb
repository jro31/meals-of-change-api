FactoryBot.define do
  factory :recipe do
    user
    name { 'My recipe name' }
    time_minutes { 45 }
    preface { 'I came up with this recipe while doing yoga on my head' }
  end
end
