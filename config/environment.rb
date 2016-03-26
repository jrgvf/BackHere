# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Custom Formats for DateTime.to_s
Time::DATE_FORMATS[:member_since] = "Membro desde %b. %Y"

Date::DATE_FORMATS[:default] = '%d/%m/%Y'