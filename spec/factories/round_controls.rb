FactoryBot.define do
  factory :v1_round_control, class: Api::V1::RoundControl do
    currencies_generated { false }
  end
end
