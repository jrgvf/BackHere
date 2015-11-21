FactoryGirl.define do
  factory :seller do
    email 'backhere@backhere.com.br'
    password 'testebackhere'
    password_confirmation "testebackhere"
    account
  end
end
