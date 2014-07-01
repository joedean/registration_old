FactoryGirl.define do
  factory :company do
    name "Acme Co"
    street_address "123 Address Ave"
    city "San Jose"
    state "CA"
    zip "95123"
    phone "408-222-2222"
    web_site "http://www.acme.co"
    status "active"
  end
end
