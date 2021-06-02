FactoryBot.define do
  factory :season, class: Season do
    finished { false }
    year     { Time.now.year }
  end
end
