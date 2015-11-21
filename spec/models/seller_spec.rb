require 'rails_helper'

RSpec.describe Seller, type: :model do

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:account) }

end
