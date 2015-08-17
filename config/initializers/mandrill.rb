require 'mandrill'

# Use an environment variable instead of placing the key in source code
MANDRILL = Mandrill::API.new ENV['MANDRILL_API_KEY']
