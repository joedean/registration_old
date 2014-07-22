FactoryGirl.define do
  factory :student do
    first_name "first"
    last_name "last"
    association :family
  end
end
