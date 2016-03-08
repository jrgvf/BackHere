module Backhere

  module VerifiableObject

    def valid?
      self[:valid]
    end

    def verified?
      self[:verified]
    end
  end

end