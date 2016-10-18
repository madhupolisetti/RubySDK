#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require File.expand_path("../../../test_helper", __FILE__)
require 'json'
require 'webmock/minitest'

class SMSTest < Minitest::Test

    # region SmsDetails class

    def test_smsdetails_constructor_and_accessors

        obj = SmsCountryApi::SMS::SmsDetails.new
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, obj, "Object isn't the correct type."
        assert_nil obj.message_uuid, "Message UUID isn't nil."
        assert_nil obj.number, "Number isn't nil."
        assert_nil obj.tool, "Tool name isn't nil."
        assert_nil obj.sender_id, "Sender ID isn't nil."
        assert_nil obj.text, "Message text isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.status_time, "Status time isn't nil."
        assert_nil obj.cost, "Cost isn't nil."

    end

    def test_smsdetails_to_hash

        t        = Time.now
        hash     = { 'MessageUUID' => UUID,
                     'Number'      => PHONE_NUMBER_1,
                     'Tool'        => 'api',
                     'SenderId'    => 'SMSCountry',
                     'Text'        => 'Text of message',
                     'Status'      => 'received',
                     'StatusTime'  => t.to_i.to_s,
                     'Cost'        => "1.25 USD" }
        obj      = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, 'Text of message',
                                                         tool:        'api',
                                                         sender_id:   "SMSCountry",
                                                         status:      'received',
                                                         status_time: t,
                                                         cost:        '1.25 USD')
        new_hash = obj.to_hash
        refute_nil new_hash, "New hash not created."
        new_hash.each do |k, v|
            assert_equal hash[k], v, "#{k} item did not match."
        end

    end

    def test_smsdetails_create

        # Required arguments only

        obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message")
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, obj, "Object isn't the correct type."
        assert_equal UUID, obj.message_uuid, "Message UUID doesn't match."
        assert_equal PHONE_NUMBER_1, obj.number, "Number doesn't match."
        assert_equal "Test message", obj.text, "Message text doesn't match."
        assert_nil obj.tool, "Tool name isn't nil."
        assert_nil obj.sender_id, "Sender ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.status_time, "Status time isn't nil."
        assert_nil obj.cost, "Cost isn't nil."

        # Optional arguments

        obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", tool: "test")
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, obj, "Object isn't the correct type."
        assert_equal UUID, obj.message_uuid, "Message UUID doesn't match."
        assert_equal PHONE_NUMBER_1, obj.number, "Number doesn't match."
        assert_equal "Test message", obj.text, "Message text doesn't match."
        assert_equal "test", obj.tool, "Tool name doesn't match."
        assert_nil obj.sender_id, "Sender ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.status_time, "Status time isn't nil."
        assert_nil obj.cost, "Cost isn't nil."

        obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", sender_id: "test")
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, obj, "Object isn't the correct type."
        assert_equal UUID, obj.message_uuid, "Message UUID doesn't match."
        assert_equal PHONE_NUMBER_1, obj.number, "Number doesn't match."
        assert_equal "Test message", obj.text, "Message text doesn't match."
        assert_nil obj.tool, "Tool name isn't nil."
        assert_equal "test", obj.sender_id, "Sender ID doesn't match."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.status_time, "Status time isn't nil."
        assert_nil obj.cost, "Cost isn't nil."

        obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", status: "test")
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, obj, "Object isn't the correct type."
        assert_equal UUID, obj.message_uuid, "Message UUID doesn't match."
        assert_equal PHONE_NUMBER_1, obj.number, "Number doesn't match."
        assert_equal "Test message", obj.text, "Message text doesn't match."
        assert_nil obj.tool, "Tool name isn't nil."
        assert_nil obj.sender_id, "Sender ID isn't nil."
        assert_equal "test", obj.status, "Status doesn't match."
        assert_nil obj.status_time, "Status time isn't nil."
        assert_nil obj.cost, "Cost isn't nil."

        t   = Time.now
        obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", status_time: t)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, obj, "Object isn't the correct type."
        assert_equal UUID, obj.message_uuid, "Message UUID doesn't match."
        assert_equal PHONE_NUMBER_1, obj.number, "Number doesn't match."
        assert_equal "Test message", obj.text, "Message text doesn't match."
        assert_nil obj.tool, "Tool name isn't nil."
        assert_nil obj.sender_id, "Sender ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_equal t, obj.status_time, "Status time doesn't match."
        assert_nil obj.cost, "Cost isn't nil."

        obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", cost: "test")
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, obj, "Object isn't the correct type."
        assert_equal UUID, obj.message_uuid, "Message UUID doesn't match."
        assert_equal PHONE_NUMBER_1, obj.number, "Number doesn't match."
        assert_equal "Test message", obj.text, "Message text doesn't match."
        assert_nil obj.tool, "Tool name isn't nil."
        assert_nil obj.sender_id, "Sender ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.status_time, "Status time isn't nil."
        assert_equal "test", obj.cost, "Cost doesn't match."

    end

    def test_smsdetails_create_bad_args

        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(nil, PHONE_NUMBER_1, "Test message")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create('', PHONE_NUMBER_1, "Test message")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(754, PHONE_NUMBER_1, "Test message")
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, nil, "Test message")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, '', "Test message")
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, 754, "Test message")
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, '')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, 754)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", tool: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", sender_id: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", status: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", status_time: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.create(UUID, PHONE_NUMBER_1, "Test message", cost: 754)
        end

    end

    def test_smsdetails_from_hash

        t    = Time.now
        hash = { 'MessageUUID' => UUID,
                 'Number'      => PHONE_NUMBER_1,
                 'Tool'        => 'api',
                 'SenderId'    => 'SMSCountry',
                 'Text'        => 'Text of message',
                 'Status'      => 'received',
                 'StatusTime'  => t.to_i.to_s,
                 'Cost'        => "1.25 USD" }
        obj  = SmsCountryApi::SMS::SmsDetails.from_hash(hash)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, obj, "Object isn't the correct type."
        assert_equal hash['MessageUUID'], obj.message_uuid, "Message UUID doesn't match."
        assert_equal hash['Number'], obj.number, "Number doesn't match."
        assert_equal hash['Tool'], obj.tool, "Tool string doesn't match."
        assert_equal hash['SenderId'], obj.sender_id, "Sender ID doesn't match."
        assert_equal hash['Text'], obj.text, "Message text doesn't match."
        assert_equal hash['Status'], obj.status, "Status doesn't match."
        assert_equal hash['StatusTime'], obj.status_time.to_i.to_s, "Status time doesn't match."
        assert_equal hash['Cost'], obj.cost, "Cost doesn't match."

        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.from_hash(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS::SmsDetails.from_hash('')
        end

    end

    # endregion SmsDetails Class

    # region SMS class

    def test_constructor

        endpoint = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy")
        refute_nil endpoint, "Endpoint was not successfully created."
        obj = SmsCountryApi::SMS.new(endpoint)
        refute_nil obj, "SMS object was not successfully created."
        assert_kind_of SmsCountryApi::SMS, obj, "SMS object isn't the right type."

        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS.new(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::SMS.new("Non-endpoint")
        end

    end


    # region #send method

    def test_send_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('SMSes'))
            .to_return(status: 202, body: { 'Success'     => true,
                                            'Message'     => "Operation succeeded",
                                            'ApiId'       => API_ID,
                                            'MessageUUID' => UUID }.to_json)

        status, message_uuid = client.sms.send(PHONE_NUMBER_1, "Test message")
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil message_uuid, "No message UUID returned."
        assert_equal UUID, message_uuid, "Returned message UUID did not match."

    end

    def test_send_bad_number_or_text

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('SMSes'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, message_uuid = client.sms.send(nil, "Test message")
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.send('', "Test message")
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.send(754, "Test message")
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.send(PHONE_NUMBER_1, nil)
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.send(PHONE_NUMBER_1, '')
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.send(PHONE_NUMBER_1, 754)
        end

    end

    def test_send_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('SMSes'))
            .to_raise(StandardError)

        status, message_uuid = client.sms.send(PHONE_NUMBER_1, "Test message")
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil message_uuid, "Returned message UUID was not nil."

    end

    # endregion #send method

    # region #bulk_send method

    def test_bulk_send_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('BulkSMSes'))
            .to_return(status: 202, body: { 'Success'      => true,
                                            'Message'      => "Operation succeeded",
                                            'ApiId'        => API_ID,
                                            'BatchUUID'    => UUID,
                                            'MessageUUIDs' => [UUID] }.to_json)

        status, batch_uuid, message_uuids = client.sms.bulk_send([PHONE_NUMBER_1], "Test message")
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil batch_uuid, "No batch UUID returned."
        assert_equal UUID, batch_uuid, "Returned batch UUID did not match."
        assert_equal 1, message_uuids.length, "Message UUID list is not the correct length."
        assert_equal UUID, message_uuids[0], "Returned message UUID did not match."

    end

    def test_bulk_send_bad_number_list_or_text

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('BulkSMSes'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, message_uuid = client.sms.bulk_send(nil, "Test message")
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.bulk_send([], "Test message")
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.bulk_send(754, "Test message")
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.bulk_send([PHONE_NUMBER_1], nil)
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.bulk_send([PHONE_NUMBER_1], '')
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.bulk_send([PHONE_NUMBER_1], 754)
        end

    end

    def test_bulk_send_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('BulkSMSes'))
            .to_raise(StandardError)

        status, batch_uuid, message_uuids = client.sms.bulk_send([PHONE_NUMBER_1], "Test message")
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil batch_uuid, "Returned batch UUID was not nil."
        assert_nil message_uuids, "Returned message UUID list was not nil."

    end

    # endregion #bulk_send method

    # region #get_details method

    def test_get_details_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        message_details_hash = { 'MessageUUID' => UUID,
                                 'Number'      => PHONE_NUMBER_1,
                                 'Tool'        => 'api',
                                 'SenderId'    => 'SMSCountry',
                                 'Text'        => 'Text of message',
                                 'Status'      => 'received',
                                 'StatusTime'  => Time.now.to_i.to_s,
                                 'Cost'        => "1.25 USD" }

        stub_request(:get, mock_uri('SMSes', UUID))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMS'     => message_details_hash }.to_json)

        status, details = client.sms.get_details(UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::SMS::SmsDetails, details, "Details are not of the correct type."
        assert_equal message_details_hash['MessageUUID'], details.message_uuid, "Details: message UUID incorrect."
        assert_equal message_details_hash['Number'], details.number, "Details: number incorrect."
        assert_equal message_details_hash['Tool'], details.tool, "Details: tool incorrect."
        assert_equal message_details_hash['SenderId'], details.sender_id, "Details: sender ID incorrect."
        assert_equal message_details_hash['Text'], details.text, "Details: text incorrect."
        assert_equal message_details_hash['Status'], details.status, "Details: status incorrect."
        assert_equal message_details_hash['StatusTime'], details.status_time.to_i.to_s, "Details: status time incorrect."
        assert_equal message_details_hash['Cost'], details.cost, "Details: cost incorrect."

    end

    def test_get_details_no_details

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('SMSes', UUID))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMS'     => nil }.to_json)

        status, details = client.sms.get_details(UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "No details included in response.", status.message, "Unexpected message in status."
        assert_nil details, "Details was not nil."

    end

    def test_get_details_bad_message_uuid

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('SMSes', UUID))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, message_uuid = client.sms.get_details(nil)
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.get_details('')
        end

        assert_raises ArgumentError do
            status, message_uuid = client.sms.get_details(754)
        end

    end

    def test_get_details_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('SMSes', UUID))
            .to_raise(StandardError)

        status, details = client.sms.get_details(UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil details, "Returned details was not nil."

    end

    # endregion #get_details method

    # region #get_collection method

    def test_get_collection_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        message_details_list = []
        message_detail_hash  = { 'MessageUUID' => UUID,
                                 'Number'      => PHONE_NUMBER_1,
                                 'Tool'        => 'api',
                                 'SenderId'    => 'SMSCountry',
                                 'Text'        => "First message",
                                 'Status'      => 'received',
                                 'StatusTime'  => Time.now.to_i.to_s,
                                 'Cost'        => "1.25 USD" }
        message_details_list.push message_detail_hash
        message_detail_hash = { 'MessageUUID' => UUID,
                                'Number'      => PHONE_NUMBER_1,
                                'Tool'        => 'api',
                                'SenderId'    => 'SMSCountry',
                                'Text'        => "Second message",
                                'Status'      => 'received',
                                'StatusTime'  => Time.now.to_i.to_s,
                                'Cost'        => "1.25 USD" }
        message_details_list.push message_detail_hash

        stub_request(:get, mock_uri('SMSes'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMSes'   => message_details_list }.to_json)

        status, details_list = client.sms.get_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of message detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "First message", details_list[0].text, "First message text isn't correct."
        assert_equal "Second message", details_list[1].text, "Second message text isn't correct."

    end

    def test_get_collection_filters

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        message_details_list = []
        message_detail_hash  = { 'MessageUUID' => UUID,
                                 'Number'      => PHONE_NUMBER_1,
                                 'Tool'        => 'api',
                                 'SenderId'    => 'SMSCountry',
                                 'Text'        => "First message",
                                 'Status'      => 'received',
                                 'StatusTime'  => Time.now.to_i.to_s,
                                 'Cost'        => "1.25 USD" }
        message_details_list.push message_detail_hash
        message_detail_hash = { 'MessageUUID' => UUID,
                                'Number'      => PHONE_NUMBER_1,
                                'Tool'        => 'api',
                                'SenderId'    => 'SMSCountry',
                                'Text'        => "Second message",
                                'Status'      => 'received',
                                'StatusTime'  => Time.now.to_i.to_s,
                                'Cost'        => "1.25 USD" }
        message_details_list.push message_detail_hash

        stub_request(:get, mock_uri('SMSes')).with(query: { 'FromDate' => '2016-09-15 00:00:00' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMSes'   => message_details_list }.to_json)

        status, details_list = client.sms.get_collection(from: Time.new(2016, 9, 15, 0, 0, 0))
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of message detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "First message", details_list[0].text, "First message text isn't correct."
        assert_equal "Second message", details_list[1].text, "Second message text isn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('SMSes')).with(query: { 'ToDate' => '2016-09-15 00:00:00' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMSes'   => message_details_list }.to_json)

        status, details_list = client.sms.get_collection(to: Time.new(2016, 9, 15, 0, 0, 0))
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of message detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "First message", details_list[0].text, "First message text isn't correct."
        assert_equal "Second message", details_list[1].text, "Second message text isn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('SMSes')).with(query: { 'SenderId' => 'SMSCountry' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMSes'   => message_details_list }.to_json)

        status, details_list = client.sms.get_collection(sender_id: 'SMSCountry')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of message detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "First message", details_list[0].text, "First message text isn't correct."
        assert_equal "Second message", details_list[1].text, "Second message text isn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('SMSes')).with(query: { 'Offset' => '5' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMSes'   => message_details_list }.to_json)

        status, details_list = client.sms.get_collection(offset: 5)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of message detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "First message", details_list[0].text, "First message text isn't correct."
        assert_equal "Second message", details_list[1].text, "Second message text isn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('SMSes')).with(query: { 'Limit' => '5' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMSes'   => message_details_list }.to_json)

        status, details_list = client.sms.get_collection(limit: 5)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of message detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "First message", details_list[0].text, "First message text isn't correct."
        assert_equal "Second message", details_list[1].text, "Second message text isn't correct."

    end

    def test_get_collection_no_detail_list

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('SMSes'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMSes'   => nil }.to_json)

        status, detail_list = client.sms.get_collection
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "No list of message details included in response.", status.message, "Unexpected message in status."
        assert_nil detail_list, "Detail list was not nil."

    end

    def test_get_collection_bad_arguments

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('SMSes'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, detail_list = client.sms.get_collection(from: '')
        end

        assert_raises ArgumentError do
            status, detail_list = client.sms.get_collection(to: '')
        end

        assert_raises ArgumentError do
            status, detail_list = client.sms.get_collection(sender_id: 574)
        end

        assert_raises ArgumentError do
            status, detail_list = client.sms.get_collection(offset: '')
        end

        assert_raises ArgumentError do
            status, detail_list = client.sms.get_collection(limit: '')
        end

    end

    def test_get_collection_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('SMSes'))
            .to_raise(StandardError)

        status, detail_list = client.sms.get_collection
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil detail_list, "Returned detail list was not nil."

    end

    # endregion #get_collection method

    # endregion SMS class

end
