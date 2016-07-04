class PhoneChecker

  def self.check_phone(phone)
    Neutrino.new(phone).check_phone
  end

end