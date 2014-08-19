FactoryGirl.define do
  factory :course do
    company
    category  "Ballet"
    name      "Ballet IIA"
    level     "IIA"
    start_age 8
    end_age   10
    wday       0
    start_at  Time.now
    end_at    Time.now
    studio    "A"
  end
end
