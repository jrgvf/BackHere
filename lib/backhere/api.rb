module Backhere
  module Api
    include CustomerActions
    include OrderActions
    include StatusActions
    include ExecutionResults

    StatusActions.module_eval do
      module_function(:find_or_create_status)
      public(:find_or_create_status)
    end

    CustomerActions.module_eval do
      module_function(:find_or_create_customer, :default_attributes, :others_attributes, :build_emails, :build_phones)
      public(:find_or_create_customer, :default_attributes, :others_attributes, :build_emails, :build_phones)
    end
  end
end