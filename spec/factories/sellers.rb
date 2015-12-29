FactoryGirl.define do
  factory :seller do
    name 'Seller BackHere'
    position 'Cargo de Teste'
    email 'backhere@backhere.com.br'
    password 'testebackhere'
    password_confirmation "testebackhere"
    account
  end
end
