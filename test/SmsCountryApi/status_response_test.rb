#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require File.expand_path("../../test_helper", __FILE__)
require 'json'

class StatusResponseTest < Minitest::Test

    def test_constructor_and_accessors

        obj = SmsCountryApi::StatusResponse.new(true, "My message", uuid: "x-y-z")
        refute_nil obj, "No object created."
        assert obj.success, "The success flag should be true."
        assert_equal "My message", obj.message, "The message is incorrect."
        assert_equal "x-y-z", obj.api_uuid, "The API UUID is incorrect."

        obj = SmsCountryApi::StatusResponse.new(false)
        refute_nil obj, "No object created."
        refute obj.success, "The success flag should be false."
        assert_nil obj.message, "There should be no message set."
        assert_nil obj.api_uuid, "There should be no API UUID."

        obj = SmsCountryApi::StatusResponse.new(true, uuid: "a-b-c")
        refute_nil obj, "No object created."
        assert obj.success, "The success flag should be true."
        assert_nil obj.message, "There should be no message set."
        assert_equal "a-b-c", obj.api_uuid, "The API UUID is incorrect."

        assert_raises ArgumentError do
            obj = SmsCountryApi::StatusResponse.new(true, 5)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::StatusResponse.new(true, "My message", uuid: 18)
        end

    end

    def test_from_hash

        h   = { 'Success' => true, 'Message' => 'My message', 'ApiId' => 'aaa-b-cccc', 'Extra' => 'Extra data' }
        obj = SmsCountryApi::StatusResponse.from_hash(h)
        refute_nil obj, "Object wasn't created."
        assert_kind_of SmsCountryApi::StatusResponse, obj, "Object isn't the correct type."
        assert obj.success, "Success flag isn't true."
        assert_equal "My message", obj.message, "Message isn't correct."
        assert_equal "aaa-b-cccc", obj.api_uuid, "API ID isn't correct."
        assert_equal 1, h.length, "Hash doesn't have the correct number of items remaining."
        assert_equal "Extra data", h['Extra'], "Extra data item wasn't preserved."

        h   = "Bogus"
        obj = SmsCountryApi::StatusResponse.from_hash(h)
        refute_nil obj, "Object wasn't created."
        assert_kind_of SmsCountryApi::StatusResponse, obj, "Object isn't the correct type."
        refute obj.success, "Success flag isn't false."
        assert_equal "StatusResponse#from_hash did not get a hash.", obj.message, "Message isn't correct."
        assert_equal nil, obj.api_uuid, "API ID isn't correct."

    end

    def test_from_response

        # Mock response object
        response_ok = Object.new

        def response_ok.code
            202
        end

        def response_ok.body
            { 'Success' => true, 'Message' => 'My message', 'ApiId' => 'aaa-b-cccc', 'Extra' => 'Extra data' }.to_json
        end

        obj, hash = SmsCountryApi::StatusResponse.from_response(response_ok)
        refute_nil obj, "Object wasn't created."
        assert_kind_of SmsCountryApi::StatusResponse, obj, "Object isn't the correct type."
        assert obj.success, "Success flag isn't true."
        assert_equal "My message", obj.message, "Message isn't correct."
        assert_equal "aaa-b-cccc", obj.api_uuid, "API ID isn't correct."
        refute_nil hash, "Hash wasn't created."
        assert_kind_of Hash, hash, "Hash isn't a hash."
        assert_equal 1, hash.length, "Hash doesn't have the correct number of items."
        assert_equal "Extra data", hash['Extra'], "Hash data wasn't correct."

        # Mock response object
        response_bad_code = Object.new

        def response_bad_code.code
            404
        end

        def response_bad_code.body
            { 'Success' => false }.to_json
        end

        obj, hash = SmsCountryApi::StatusResponse.from_response(response_bad_code)
        refute_nil obj, "Object wasn't created."
        assert_kind_of SmsCountryApi::StatusResponse, obj, "Object isn't the correct type."
        refute obj.success, "Success flag isn't false."
        assert_equal "HTTP code 404: {\"Success\":false}", obj.message, "Message isn't correct."
        refute_nil hash, "Hash wasn't created."
        assert_kind_of Hash, hash, "Hash isn't a hash."
        assert_equal 0, hash.length, "Hash doesn't have the correct number of items."

        # Mock response object
        response_bad_body = Object.new

        def response_bad_body.code
            202
        end

        def response_bad_body.body
            "Not JSON"
        end

        obj, hash = SmsCountryApi::StatusResponse.from_response(response_bad_body)
        refute_nil obj, "Object wasn't created."
        assert_kind_of SmsCountryApi::StatusResponse, obj, "Object isn't the correct type."
        refute obj.success, "Success flag isn't false."
        assert_equal "Unparseable response: Not JSON", obj.message, "Message isn't correct."
        refute_nil hash, "Hash wasn't created."
        assert_kind_of Hash, hash, "Hash isn't a hash."
        assert_equal 0, hash.length, "Hash doesn't have the correct number of items."

    end

end
