#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require File.expand_path("../../test_helper", __FILE__)
require 'base64'

class EndpointTest < Minitest::Test

    def test_regular_constructor_and_accessors

        # Standard valid authentication key and token
        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy")
        refute_nil obj, "Endpoint was not successfully created."
        assert_equal "abcdefghijkl", obj.key, "Authentication key is incorrect."
        assert_equal "xyzzy", obj.token, "Authentication token is incorrect."
        assert_equal "https://restapi.smscountry.com/v0.1/Accounts/abcdefghijkl/", obj.url,
                     "Default endpoint URL is incorrect."
        assert_equal "abcdefghijkl:xyzzy", Base64::decode64(obj.authorization),
                     "Authorization string is incorrect."

        # Various invalid authentication keys and tokens
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new(nil, "xyzzy")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new("", "xyzzy")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new(5, "xyzzy")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new("abcdefghijkl", nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new("abcdefghijkl", 5)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new(nil, nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new("", "")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Endpoint.new(5, 5)
        end

    end

    def test_constructor_endpoint_parameters

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", use_ssl: false)
        assert_equal "http://restapi.smscountry.com/v0.1/Accounts/abcdefghijkl/", obj.url,
                     "Endpoint is not using plain HTTP."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", host: "rest.endpoint.com")
        assert_equal "https://rest.endpoint.com/v0.1/Accounts/abcdefghijkl/", obj.url,
                     "Endpoint is not using rest.endpoint.com."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", path: "api/testing/endpoint")
        assert_equal "https://restapi.smscountry.com/api/testing/endpoint/abcdefghijkl/", obj.url,
                     "Endpoint is not using api/testing/endpoint."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", path: "/api/testing/endpoint/")
        assert_equal "https://restapi.smscountry.com/api/testing/endpoint/abcdefghijkl/", obj.url,
                     "Endpoint failed stripping leading or trailing slashes."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", path: "////api/testing/endpoint//")
        assert_equal "https://restapi.smscountry.com/api/testing/endpoint/abcdefghijkl/", obj.url,
                     "Endpoint failed stripping multiple leading or trailing slashes."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", path: "   api/testing/endpoint      ")
        assert_equal "https://restapi.smscountry.com/api/testing/endpoint/abcdefghijkl/", obj.url,
                     "Endpoint failed stripping leading or trailing whitespace."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", path: "   /api/testing/endpoint/     ")
        assert_equal "https://restapi.smscountry.com/api/testing/endpoint/abcdefghijkl/", obj.url,
                     "Endpoint failed stripping leading or trailing whitespace plus slashes."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", path: "    ///api/testing/endpoint////      ")
        assert_equal "https://restapi.smscountry.com/api/testing/endpoint/abcdefghijkl/", obj.url,
                     "Endpoint failed stripping leading or trailing whitespace plus multiple slashes."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", path: "  / api/testing/endpoint  //  ")
        assert_equal "https://restapi.smscountry.com/ api/testing/endpoint  /abcdefghijkl/", obj.url,
                     "Endpoint failed leaving whitespace inside leading and trailing slashes."

        obj = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy", path: "")
        assert_equal "https://restapi.smscountry.com/abcdefghijkl/", obj.url,
                     "Endpoint is not accepting an empty path."

    end

end
