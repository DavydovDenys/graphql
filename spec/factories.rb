FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
  end

  factory :project do
    name { Faker::Name.name }
    user_id { nil }
  end
end