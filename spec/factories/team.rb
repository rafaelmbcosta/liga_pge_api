FactoryBot.define do
  factory :v1_team, class: Api::V1::Team do
    name    { "#{Faker::Team.name} FC" }
    active  { true }
  end
end
