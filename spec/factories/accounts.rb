FactoryGirl.define do
  factory :account do
    name 'Back Here Account'
    default_email 'backhere@backhere.com.br'
    
    after(:create) do |account|
      Tenant.current_tenant = account
    end
  end
end
