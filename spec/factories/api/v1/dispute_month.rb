FactoryGirl.define do
  factory :dispute_month, class: Api::V1::DisputeMonth do
    name     { Date::MONTHNAMES[rand(1..11)] }
  end
end
