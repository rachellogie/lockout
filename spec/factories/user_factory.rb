FactoryGirl.define do
  factory :user do
    email 'bob@example.com'
    password  'password'
    password_confirmation 'password'
  end
end
