FactoryBot.define do
  factory :v1_dispute_month, class: Api::V1::DisputeMonth do
    name     { Date::MONTHNAMES[rand(1..11)] }
  end
end
