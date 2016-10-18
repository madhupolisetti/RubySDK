#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'SmsCountryApi'

require 'minitest/autorun'

# Invalid phone number for use in testing.
PHONE_NUMBER_1 = '19909589191'
PHONE_NUMBER_2 = '19909580256'

# API UUID for use in testing.
API_ID         = '123e4567-e89b-12d3-a456-426655440000'

# Bogus UUID for use in testing.
UUID           = '123e4567-e89b-12d3-a456-426655440011'

# Base string for mock URI.
MOCK_URI_BASE  = 'http://localhost/api/jYyz0aHhTnpCnZg852Kx/'

# Generic mock URI regexp
MOCK_URI       = %r|http://localhost/api/jYyz0aHhTnpCnZg852Kx/.*|

# Create and return a mock URI regexp based on parameters.
#
# @return [Regexp] Regular expression matching the requested URI.
#
def mock_uri(*parts)
    result = '^' + MOCK_URI_BASE
    unless parts.nil? || parts.empty?
        parts.each do |p|
            result += p.to_s + '/' unless p.to_s.empty?
        end
    end
    result += '(?:\\?.*)?$'
    Regexp.new(result)
end

# Create a client using a mock endpoint suitable for use when stubbing out responses
# during unit testing.
#
# @return [Client] Client object.
#
def create_mock_client
    endpoint = SmsCountryApi::Endpoint.new('jYyz0aHhTnpCnZg852Kx', 'D8Vuo3UTf882LhIz6YBmTNMxCDgoPnVw7GGyLVbi',
                                           use_ssl: false,
                                           host:    'localhost',
                                           path:    'api')
    SmsCountryApi::Client.new(endpoint)
end

# Create a client using the Apiary mock server for integration testing.
#
# @return [Client] Client object.
#
def create_test_client
    endpoint = SmsCountryApi::Endpoint.new('jYyz0aHhTnpCnZg852Kx', nil,
                                           use_ssl: true,
                                           host:    'private-d9e58-smscountryapi.apiary-mock.com',
                                           path:    'v0.1/Accounts')
    SmsCountryApi::Client.new(endpoint)
end
