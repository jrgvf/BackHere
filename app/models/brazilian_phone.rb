class BrazilianPhone

  NORMALIZE_REGEX               = /\D/
  BRAZILIAN_PHONE_REGEX         = /\A(?<country_code>55|055|)(?<region_code>0\d{1,2}|\d{1,2})(?<number>\d+)/

  def initialize(match_result)
    @country_code = match_result[:country_code].to_s
    @region_code = match_result[:region_code].to_s
    @number = match_result[:number].to_s
  end

  def country_code
    @country_code = "55" if @country_code.blank?
    @country_code.start_with?("0") ? @country_code[1..-1] : @country_code
  end

  def region_code
    @region_code.start_with?("0") ? @region_code[1..-1] : @region_code
  end

  def number
    @number
  end

  def self.format(remote_phone)
    normalized_phone  = BrazilianPhone.normalize(remote_phone.to_s)
    result            = BRAZILIAN_PHONE_REGEX.match(normalized_phone) || {}
    brazilian_phone   = BrazilianPhone.new(result)

    {
      country_code: brazilian_phone.country_code,
      region_code:  brazilian_phone.region_code,
      number:       brazilian_phone.number
    }
  end

  def self.normalize(remote_phone)
    remote_phone.gsub(NORMALIZE_REGEX, '')
  end

  def self.to_string(remote_phone)
    phone = BrazilianPhone.format(remote_phone)
    return "" if phone[:number].blank? || phone[:region_code].blank?
    
    "+#{phone[:country_code]} (#{phone[:region_code]}) #{phone[:number]}"
  end

  def self.to_s(remote_phone)
    BrazilianPhone.to_string(remote_phone)
  end

  # def self.format2(remote_phone)
  #   complete_phone = BrazilianPhone.normalize(remote_phone)
  #   BRAZILIAN_PHONE_REGEX =~ complete_phone
  #   Hash[$~.names.collect{|x| [x.to_sym, $~[x]]}]
  # end

end