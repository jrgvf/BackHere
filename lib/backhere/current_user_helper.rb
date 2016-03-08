module Backhere

  module CurrentUserHelper

    def is_seller?
      self.is_a?(Seller)
    end

    def is_admin?
      self.is_a?(Admin)
    end

    def is_user?
      self.is_a?(User)
    end
  end

end