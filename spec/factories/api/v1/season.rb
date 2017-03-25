FactoryGirl.define do
  factory :season, class: Api::V1::Season do
    year     { Faker::Number.number(4) }
    finished { false }
  end
end
