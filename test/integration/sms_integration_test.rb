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

        status, message_uuid = @client.sms.send(PHONE_NUMBER_1, "Test message")
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil message_uuid, "No message UUID returned."

        status, details = @client.sms.get_details(message_uuid)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuid, details.message_uuid, "Returned message UUID isn't correct."

    end

    def test_bulk_message_send

        status, batch_uuid, message_uuids = @client.sms.bulk_send([PHONE_NUMBER_1, PHONE_NUMBER_2], "Test message")
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil message_uuids, "No message UUID returned."

        status, details = @client.sms.get_details(message_uuids[0])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuids[0], details.message_uuid, "Returned message UUID 1 isn't correct."

        status, details = @client.sms.get_details(message_uuids[1])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_uuids[1], details.message_uuid, "Returned message UUID 2 isn't correct."

    end

    def test_get_collection

        # TODO

    end

end
