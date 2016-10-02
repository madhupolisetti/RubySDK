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
PHONE_NUMBER = '19909589191'

# API UUID for use in testing.
API_ID = '123e4567-e89b-12d3-a456-426655440000'

# Bogus UUID for use in testing.
UUID = '123e4567-e89b-12d3-a456-426655440011'

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

# Regexp matching URIs used with the mock client.
MOCK_URI = /localhost\/api\/.*/

# Create a client using the Apiary mock server for integration testing.
#
# @return [Client] Client object.
#
def create_test_client
    endpoint = SmsCountryApi::Endpoint.new('jYyz0aHhTnpCnZg852Kx', 'D8Vuo3UTf882LhIz6YBmTNMxCDgoPnVw7GGyLVbi',
                                           use_ssl: true,
                                           host:    'private-anon-e01a3bdef0-smscountryapi.apiary-mock.com',
                                           path:    'v0.1/Accounts')
    SmsCountryApi::Client.new(endpoint)
end
