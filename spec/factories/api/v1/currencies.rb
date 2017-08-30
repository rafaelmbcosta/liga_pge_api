FactoryGirl.define do
  factory :currency do
    value { Faker::Commerce.price }
  end
end
