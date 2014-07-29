# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Custom date formats
my_time_formats = { :time_only => '%l:%M %P' }
Time::DATE_FORMATS.merge!(my_time_formats)
