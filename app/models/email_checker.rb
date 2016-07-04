class EmailChecker

  def self.check_email(email)
    QuickEmailVerification.new(email).check_email
  end

end