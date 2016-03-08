module Backhere

  module VerifiableObject

    def is_valid?
      self[:is_valid]
    end

    def verified?
      self[:verified]
    end
  end

end