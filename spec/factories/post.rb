# This will guess the User class
FactoryBot.define do
  factory :post do
    title "test post please ignore"
    url { unique_url }
    after(:build) do |post|
      cat = create(:category)
      post.categories << cat
    end
  end
end
