#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require File.expand_path("../../test_helper", __FILE__)

class SMSIntegrationTest < Minitest::Test

    def setup

        @client = create_test_client
        refute_nil @client, "Client object couldn't be created."

    end

    def test_single_message_send

        status, message_uuid = @client.sms.send(PHONE_NUMBERS[0], "Test message")
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil message_uuid, "No message UUID returned."

        status, details = @client.sms.get_details(message_uuid)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuid, details.message_uuid, "Returned message UUID isn't correct."
        # TODO Mock server support needed
        #assert_equal PHONE_NUMBERS[0], details.number, "Phone number isn't correct."
        #assert_equal "Test message", details.text, "Message text isn't correct."

    end

    def test_single_message_send_optional_args

        status, message_uuid = @client.sms.send(PHONE_NUMBERS[0], "Optional message",
                                                sender_id:          'SmsOptional',
                                                notify_url:         NOTIFY_URL,
                                                notify_http_method: 'GET')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil message_uuid, "No message UUID returned."

        status, details = @client.sms.get_details(message_uuid)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuid, details.message_uuid, "Returned message UUID isn't correct."
        # TODO Mock server support needed
        #assert_equal PHONE_NUMBERS[0], details.number, "Phone number isn't correct."
        #assert_equal "Optional message", details.text, "Message text isn't correct."
        #assert_equal 'SmsOptional', details.sender_id, "Sender ID isn't correct."

    end

    def test_bulk_message_send

        status, batch_uuid, message_uuids = @client.sms.bulk_send([PHONE_NUMBERS[0], PHONE_NUMBERS[1]],
                                                                  "Test message")
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil message_uuids, "No message UUIDs returned."
        assert_kind_of Array, message_uuids, "Message UUID list isn't an array."
        assert_equal 2, message_uuids.length, "Message UUID list doesn't have 2 items."

        status, details = @client.sms.get_details(message_uuids[0])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuids[0], details.message_uuid, "Returned message UUID 1 isn't correct."
        # TODO Mock server support needed
        #assert_equal PHONE_NUMBERS[0], details.number, "Phone number 1 isn't correct."
        #assert_equal "Test message", details.text, "Message 1 text isn't correct."

        status, details = @client.sms.get_details(message_uuids[1])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuids[1], details.message_uuid, "Returned message UUID 2 isn't correct."
        # TODO Mock server support needed
        #assert_equal PHONE_NUMBERS[1], details.number, "Phone number 2 isn't correct."
        #assert_equal "Test message", details.text, "Message text 2 isn't correct."

    end

    def test_bulk_message_send_optional_args

        status, batch_uuid, message_uuids = @client.sms.bulk_send([PHONE_NUMBERS[0], PHONE_NUMBERS[1]],
                                                                  "Optional message",
                                                                  sender_id:          'SmsOptional',
                                                                  notify_url:         NOTIFY_URL,
                                                                  notify_http_method: 'GET')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil message_uuids, "No message UUIDs returned."
        assert_kind_of Array, message_uuids, "Message UUID list isn't an array."
        assert_equal 2, message_uuids.length, "Message UUID list doesn't have 2 items."

        status, details = @client.sms.get_details(message_uuids[0])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuids[0], details.message_uuid, "Returned message UUID 1 isn't correct."
        # TODO Mock server support needed
        #assert_equal PHONE_NUMBERS[0], details.number, "Phone number 1 isn't correct."
        #assert_equal "Optional message", details.text, "Message 1 text isn't correct."
        #assert_equal 'SmsOptional', details.sender_id, "Sender ID 1 isn't correct."

        status, details = @client.sms.get_details(message_uuids[1])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuids[1], details.message_uuid, "Returned message UUID 2 isn't correct."
        # TODO Mock server support needed
        #assert_equal PHONE_NUMBERS[1], details.number, "Phone number 2 isn't correct."
        #assert_equal "Optional message", details.text, "Message text 2 isn't correct."
        #assert_equal 'SmsOptional', details.sender_id, "Sender ID 2 isn't correct."

    end

    def test_get_collection

        status, batch_uuid, message_uuids = @client.sms.bulk_send([PHONE_NUMBERS[0], PHONE_NUMBERS[1]],
                                                                  "Get collection message",
                                                                  sender_id: 'GETCOLL')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil message_uuids, "No message UUIDs returned."
        assert_kind_of Array, message_uuids, "Message UUID list isn't an array."
        assert_equal 2, message_uuids.length, "Message UUID list doesn't have 2 items."

        status, details_list = @client.sms.get_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of message detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert details_list.length >= 2, "Details list isn't long enough."
        message_uuids.each do |uuid|
            assert details_list.any? { |d| d.message_uuid == uuid }, "Message UUID #{uuid} not found in collection."
        end

    end

end
