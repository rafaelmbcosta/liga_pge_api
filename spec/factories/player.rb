FactoryBot.define do
  factory :v1_player, class: Api::V1::Player do
    name    { Faker::Name.name }
    active  { true }
  end
end
