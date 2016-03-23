module CustomersHelper

  def attribute_name(name)
    "#{name.to_s.capitalize}:"
  end

  def date_or_time_attribute?(value)
    [DateTime, Date, Time].each do |klass|
      return true if value.is_a?(klass)
    end
    false
  end

end
