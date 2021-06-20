FactoryBot.define do
  factory :team, class: Team do
    name           { "#{Faker::Team.name} FC" }
    player_name    { Faker::Name.name }
    active         { true }
  end
end
