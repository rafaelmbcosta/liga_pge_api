FactoryBot.define do
  factory :v1_season, class: Api::V1::Season do
    finished { false }
    year     { Faker::Date.between(Date.today, 5.year.from_now).year }
  end
end
