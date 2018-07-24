FactoryBot.define do
  factory :v1_round, class: Api::V1::Round do
    number    { rand(38) + 1 }
    golden    { false }
    finished  { false }
  end
end
