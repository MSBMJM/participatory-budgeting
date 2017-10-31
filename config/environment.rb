# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

#set environment, extremely useful when hosting multiple instances
ENV["RAILS_ENV"] = "development"