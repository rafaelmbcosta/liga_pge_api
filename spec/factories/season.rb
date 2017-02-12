FactoryGirl.define do
  factory :season do
    year     { Faker::Number.number(4) }
    finished { false }
  end
end
