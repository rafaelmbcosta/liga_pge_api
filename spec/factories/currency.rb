FactoryBot.define do
  factory :currency, class: Currency do
    difference { Faker::Commerce.price }
  end
end
