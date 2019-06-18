FactoryBot.define do
  factory :v1_currency, class: Api::V1::Currency do
    difference { Faker::Commerce.price }
  end
end
