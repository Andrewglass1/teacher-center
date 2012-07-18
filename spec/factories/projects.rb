FactoryGirl.define do

  factory :project do
    title "Hello World"
    expiration_date Date.today
  end

end