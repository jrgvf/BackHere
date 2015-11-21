require 'rails_helper'

RSpec.describe Account, type: :model do

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:sellers) }

end
