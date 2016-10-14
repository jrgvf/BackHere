 class Tenant

  def self.current=(tenant)
    Mongoid::Multitenancy.current_tenant = tenant
  end

  def self.current
    Mongoid::Multitenancy.current_tenant
  end

  def self.clean
    self.current = nil
  end

  def self.with_tenant(tenant)
    Mongoid::Multitenancy.with_tenant(tenant) do
      yield
    end
  end

end