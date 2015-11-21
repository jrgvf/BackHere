FactoryGirl.define do
  factory :account do
    name 'Back Here Account'
    
    after(:create) do |account|
      Mongoid::Multitenancy.current_tenant = account
    end
  end
end
