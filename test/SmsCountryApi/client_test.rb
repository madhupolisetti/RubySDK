#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require File.expand_path("../../test_helper", __FILE__)

class ClientTest < Minitest::Test

    def test_constructor_and

        endpoint = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy")

        obj = SmsCountryApi::Client.new(endpoint)
        refute_nil obj, "Client object was not successfully created."
        refute_nil obj.sms, "Client object does not have SMS access."
        refute_nil obj.call, "Client object does not have Call access."
        refute_nil obj.group, "Client object does not have Group access."
        refute_nil obj.group_call, "Client object does not have GroupCall access."

        assert_raises ArgumentError do
            obj = SmsCountryApi::Client.new(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Client.new("Non-endpoint")
        end

    end

    def test_create_client

        obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy")
        refute_nil obj, "Client object was not successfully created."
        assert_kind_of SmsCountryApi::Client, obj, "Created object is of the wrong type."

        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client(nil, "xyzzy")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client('', "xyzzy")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client(5, "xyzzy")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", '')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", 5)
        end

        obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                 protocol: 'http',
                                                 host:     'localhost',
                                                 path:     '/api/endpoint')
        refute_nil obj, "Client object was not successfully created."
        assert_kind_of SmsCountryApi::Client, obj, "Created object is of the wrong type."

        obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                 protocol: 'http',
                                                 host:     'localhost',
                                                 path:     '')
        refute_nil obj, "Client object was not successfully created."
        assert_kind_of SmsCountryApi::Client, obj, "Created object is of the wrong type."

        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                     protocol: nil,
                                                     host:     'localhost',
                                                     path:     '/api/endpoint')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                     protocol: '',
                                                     host:     'localhost',
                                                     path:     '/api/endpoint')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                     protocol: 15,
                                                     host:     'localhost',
                                                     path:     '/api/endpoint')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                     protocol: 'ftp',
                                                     host:     'localhost',
                                                     path:     '/api/endpoint')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                     protocol: 'http',
                                                     host:     '',
                                                     path:     '/api/endpoint')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                     protocol: 'http',
                                                     host:     15,
                                                     path:     '/api/endpoint')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi.create_client("abcdefghijkl", "xyzzy",
                                                     protocol: 'http',
                                                     host:     'localhost',
                                                     path:     15)
        end

    end

end
