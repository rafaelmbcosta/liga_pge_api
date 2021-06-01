FactoryBot.define do
  factory :season, class: Season do
    finished { false }
    year     { 2021 }
  end
end
