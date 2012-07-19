FactoryGirl.define do

  factory :project do
    title "Hello World"
    expiration_date Date.today
    description Faker::Lorem.words(5).join(' ')
  end

end
