FactoryGirl.define do
  factory :user, class:User do
    password              'password'
    password_confirmation 'password'

    sequence :email do |n|
      "user#{n}@example.com"
    end
  end
end
