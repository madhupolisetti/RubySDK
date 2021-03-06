#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require File.expand_path("../../../test_helper", __FILE__)
require 'json'
require 'webmock/minitest'

class CallTest < Minitest::Test

    # region CallDetails class

    def test_calldetails_constructor_and_accessors

        obj = SmsCountryApi::Call::CallDetails.new
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_nil obj.number, "Number isn't nil."
        assert_nil obj.call_uuid, "Call UUID isn't nil."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

    end

    def test_calldetails_to_hash

        t        = Time.now
        hash     = { 'CallUUID'      => UUID,
                     'Number'        => PHONE_NUMBERS[0],
                     'CallerId'      => 'SMSCountry',
                     'Status'        => 'completed',
                     'RingTime'      => t.to_i.to_s,
                     'AnswerTime'    => t.to_i.to_s,
                     'EndTime'       => t.to_i.to_s,
                     'EndReason'     => 'NORMAL',
                     'Cost'          => "1.25 USD",
                     'Direction'     => 'Outbound',
                     'Pulse'         => '30',
                     'Pulses'        => '1',
                     'PricePerPulse' => '0.7' }
        obj      = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID,
                                                           caller_id:       "SMSCountry",
                                                           status:          'completed',
                                                           ring_time:       t,
                                                           answer_time:     t,
                                                           end_time:        t,
                                                           end_reason:      "NORMAL",
                                                           cost:            '1.25 USD',
                                                           direction:       "Outbound",
                                                           pulse:           30,
                                                           pulses:          1,
                                                           price_per_pulse: 0.7)
        new_hash = obj.to_hash
        refute_nil new_hash, "New hash not created."
        new_hash.each do |k, v|
            assert_equal hash[k], v, "#{k} item did not match."
        end

    end

    def test_calldetails_create

        # Required arguments only

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        # Optional arguments
        t = Time.now

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, caller_id: 'test')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_equal 'test', obj.caller_id, "Caller ID doesn't match."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, status: 'test')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_equal 'test', obj.status, "Status doesn't match."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, ring_time: t)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_equal t, obj.ring_time, "Ring time doesn't match."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        t   = Time.now
        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, answer_time: t)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_equal t, obj.answer_time, "Answer time doesn't match."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, end_time: t)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_equal t, obj.end_time, "End time doesn't match."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, end_reason: 'test')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_equal 'test', obj.end_reason, "End reason doesn't match."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, cost: 'test')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_equal 'test', obj.cost, "Cost doesn't match."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, direction: 'test')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_equal 'test', obj.direction, "Direction doesn't match."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, pulse: 5)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_equal 5, obj.pulse, "Pulse doesn't match."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, pulses: 5)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_equal 5, obj.pulses, "Pulses doesn't match."
        assert_nil obj.price_per_pulse, "Price per pulse isn't nil."

        obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, price_per_pulse: 5.0)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBERS[0], obj.number, "Number doesn't match."
        assert_equal UUID, obj.call_uuid, "Call UUID doesn't match."
        assert_nil obj.caller_id, "Caller ID isn't nil."
        assert_nil obj.status, "Status isn't nil."
        assert_nil obj.ring_time, "Ring time isn't nil."
        assert_nil obj.answer_time, "Answer time isn't nil."
        assert_nil obj.end_time, "End time isn't nil."
        assert_nil obj.end_reason, "End reason isn't nil."
        assert_nil obj.cost, "Cost isn't nil."
        assert_nil obj.direction, "Direction isn't nil."
        assert_nil obj.pulse, "Pulse isn't nil."
        assert_nil obj.pulses, "Pulses isn't nil."
        assert_equal 5.0, obj.price_per_pulse, "Price per pulse doesn't match."

    end

    def test_calldetails_create_bad_args

        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], '')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], 754)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(nil, UUID)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create('', UUID)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(754, UUID)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, caller_id: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, status: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, ring_time: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, answer_time: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, end_time: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, end_reason: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, cost: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, direction: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, pulse: '5')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, pulses: '5')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.create(PHONE_NUMBERS[0], UUID, price_per_pulse: 754)
        end

    end

    def test_calldetails_from_hash

        t    = Time.now
        hash = { 'CallUUID'      => UUID,
                 'Number'        => PHONE_NUMBERS[0],
                 'CallerId'      => 'SMSCountry',
                 'Status'        => 'completed',
                 'RingTime'      => t.to_i.to_s,
                 'AnswerTime'    => t.to_i.to_s,
                 'EndTime'       => t.to_i.to_s,
                 'EndReason'     => 'NORMAL',
                 'Cost'          => "1.25 USD",
                 'Direction'     => 'Outbound',
                 'Pulse'         => '30',
                 'Pulses'        => '1',
                 'PricePerPulse' => '0.7' }
        obj  = SmsCountryApi::Call::CallDetails.from_hash(hash)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Call::CallDetails, obj, "Object isn't the correct type."
        assert_equal hash['CallUUID'], obj.call_uuid, "Caller UUID doesn't match."
        assert_equal hash['Number'], obj.number, "Number doesn't match."
        assert_equal hash['CallerId'], obj.caller_id, "Caller ID doesn't match."
        assert_equal hash['Status'], obj.status, "Status doesn't match."
        assert_equal hash['RingTime'], obj.ring_time.to_i.to_s, "Ring time doesn't match."
        assert_equal hash['AnswerTime'], obj.answer_time.to_i.to_s, "Answer time doesn't match."
        assert_equal hash['EndTime'], obj.end_time.to_i.to_s, "End time doesn't match."
        assert_equal hash['EndReason'], obj.end_reason, "End reason doesn't match."
        assert_equal hash['Cost'], obj.cost, "Cost doesn't match."
        assert_equal hash['Direction'], obj.direction, "Direction doesn't match."
        assert_equal hash['Pulse'].to_i, obj.pulse, "Pulse doesn't match."
        assert_equal hash['Pulses'].to_i, obj.pulses, "Pulses doesn't match."
        assert_equal hash['PricePerPulse'].to_f, obj.price_per_pulse, "Price per pulse doesn't match."

        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.from_hash(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Call::CallDetails.from_hash('')
        end

    end

    # endregion CallDetails class

    # region Call class

    def test_constructor

        endpoint = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy")
        refute_nil endpoint, "Endpoint was not successfully created."
        obj = SmsCountryApi::Call.new(endpoint)
        refute_nil obj, "Call object was not successfully created."
        assert_kind_of SmsCountryApi::Call, obj, "Call object isn't the right type."

        assert_raises ArgumentError do
            obj = SmsCountryApi::Call.new(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Call.new("Non-endpoint")
        end

    end


    # region #initiate_call method

    def test_initiate_call_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('Calls'))
            .to_return(status: 202, body: { 'Success'  => true,
                                            'Message'  => "Operation succeeded",
                                            'ApiId'    => API_ID,
                                            'CallUUID' => UUID }.to_json)

        status, call_uuid = client.call.initiate_call(PHONE_NUMBERS[0])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil call_uuid, "No call UUID returned."
        assert_equal UUID, call_uuid, "Returned call UUID did not match."

    end

    def test_initiate_call_bad_number

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('Calls'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, call_uuid = client.call.initiate_call(nil)
        end

        assert_raises ArgumentError do
            status, call_uuid = client.call.initiate_call('')
        end

        assert_raises ArgumentError do
            status, call_uuid = client.call.initiate_call(754)
        end

    end

    def test_initiate_call_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('Calls'))
            .to_raise(StandardError)

        status, call_uuid = client.call.initiate_call(PHONE_NUMBERS[0])
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil call_uuid, "Returned call UUID was not nil."

    end

    # endregion #initiate_call method

    # region #initiate_bulk_call method

    def test_initiate_bulk_call_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('BulkCalls'))
            .to_return(status: 202, body: { 'Success'   => true,
                                            'Message'   => "Operation succeeded",
                                            'ApiId'     => API_ID,
                                            'BatchUUID' => UUID,
                                            'CallUUIDs' => [UUID] }.to_json)

        status, call_uuids = client.call.initiate_bulk_call([PHONE_NUMBERS[0]])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        assert_equal 1, call_uuids.length, "call UUID list is not the correct length."
        assert_equal UUID, call_uuids[0], "Returned call UUID did not match."

    end

    def test_initiate_bulk_call_bad_number_list

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('BulkCalls'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, call_uuid = client.call.initiate_bulk_call(nil)
        end

        assert_raises ArgumentError do
            status, call_uuid = client.call.initiate_bulk_call([])
        end

        assert_raises ArgumentError do
            status, call_uuid = client.call.initiate_bulk_call(754)
        end

    end

    def test_initiate_bulk_call_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('BulkCalls'))
            .to_raise(StandardError)

        status, call_uuids = client.call.initiate_bulk_call([PHONE_NUMBERS[0]])
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil call_uuids, "Returned call UUID list was not nil."

    end

    # endregion #initiate_bulk_call method

    # region #terminate_call method

    def test_terminate_call_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('Calls', UUID))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, = client.call.terminate_call(UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message

    end

    def test_terminate_call_bad_call_uuid

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('Calls', UUID))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, call_uuid = client.call.terminate_call(nil)
        end

        assert_raises ArgumentError do
            status, call_uuid = client.call.terminate_call('')
        end

        assert_raises ArgumentError do
            status, call_uuid = client.call.terminate_call(754)
        end

    end

    def test_terminate_call_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('Calls', UUID))
            .to_raise(StandardError)
        status, = client.call.terminate_call(UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #terminate_call method

    # region #get_details method

    def test_get_details_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        call_details_hash = { 'CallUUID'      => UUID,
                              'Number'        => PHONE_NUMBERS[0],
                              'CallerId'      => 'SMSCountry',
                              'Status'        => 'completed',
                              'RingTime'      => Time.now.to_i.to_s,
                              'AnswerTime'    => Time.now.to_i.to_s,
                              'EndTime'       => Time.now.to_i.to_s,
                              'EndReason'     => 'NORMAL',
                              'Cost'          => "1.25 USD",
                              'Direction'     => 'Outbound',
                              'Pulse'         => '30',
                              'Pulses'        => '1',
                              'PricePerPulse' => '0.7' }

        stub_request(:get, mock_uri('Calls', UUID))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Call'    => call_details_hash }.to_json)

        status, details = client.call.get_details(UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No details returned."
        assert_kind_of SmsCountryApi::Call::CallDetails, details, "Details are not of the correct type."
        assert_equal call_details_hash['CallUUID'], details.call_uuid, "Details: message UUID incorrect."
        assert_equal call_details_hash['Number'], details.number, "Details: number incorrect."
        assert_equal call_details_hash['CallerId'], details.caller_id, "Details: caller ID incorrect."
        assert_equal call_details_hash['Status'], details.status, "Details: status incorrect."
        assert_equal call_details_hash['RingTime'], details.ring_time.to_i.to_s, "Details: ring time incorrect."
        assert_equal call_details_hash['AnswerTime'], details.answer_time.to_i.to_s, "Details: answer time incorrect."
        assert_equal call_details_hash['EndTime'], details.end_time.to_i.to_s, "Details: end time incorrect."
        assert_equal call_details_hash['EndReason'], details.end_reason, "Details: end reason incorrect."
        assert_equal call_details_hash['Cost'], details.cost, "Details: cost incorrect."

    end

    def test_get_details_no_details

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('Calls', UUID))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'SMS'     => nil }.to_json)
        status, details = client.call.get_details(UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "No details included in response.", status.message, "Unexpected message in status."
        assert_nil details, "Details was not nil."

    end

    def test_get_details_bad_call_uuid

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('Calls', UUID))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, call_uuid = client.call.get_details(nil)
        end

        assert_raises ArgumentError do
            status, call_uuid = client.call.get_details('')
        end

        assert_raises ArgumentError do
            status, call_uuid = client.call.get_details(754)
        end

    end

    def test_get_details_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('Calls', UUID))
            .to_raise(StandardError)

        status, details = client.call.get_details(UUID)
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

        call_details_list = []
        call_detail_hash  = { 'CallUUID'      => UUID,
                              'Number'        => PHONE_NUMBERS[0],
                              'CallerId'      => 'SMSCountry',
                              'Status'        => 'completed',
                              'RingTime'      => Time.now.to_i.to_s,
                              'AnswerTime'    => Time.now.to_i.to_s,
                              'EndTime'       => Time.now.to_i.to_s,
                              'EndReason'     => 'NORMAL',
                              'Cost'          => "1.25 USD",
                              'Direction'     => 'Outbound',
                              'Pulse'         => '30',
                              'Pulses'        => '1',
                              'PricePerPulse' => '0.7' }
        call_details_list.push call_detail_hash
        call_detail_hash = { 'CallUUID'      => UUID,
                             'Number'        => PHONE_NUMBERS[0],
                             'CallerId'      => 'SMSCountry',
                             'Status'        => 'completed',
                             'RingTime'      => Time.now.to_i.to_s,
                             'AnswerTime'    => Time.now.to_i.to_s,
                             'EndTime'       => Time.now.to_i.to_s,
                             'EndReason'     => 'HANGUP',
                             'Cost'          => "1.25 USD",
                             'Direction'     => 'Outbound',
                             'Pulse'         => '30',
                             'Pulses'        => '1',
                             'PricePerPulse' => '0.7' }
        call_details_list.push call_detail_hash

        stub_request(:get, mock_uri('Calls'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list }.to_json)

        status, details_list, _, _ = client.call.get_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."

    end

    def test_get_collection_filters

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        call_details_list = []
        call_detail_hash        = { 'CallUUID'      => UUID,
                                    'Number'        => PHONE_NUMBERS[0],
                                    'CallerId'      => 'SMSCountry',
                                    'Status'        => 'completed',
                                    'RingTime'      => Time.now.to_i.to_s,
                                    'AnswerTime'    => Time.now.to_i.to_s,
                                    'EndTime'       => Time.now.to_i.to_s,
                                    'EndReason'     => 'NORMAL',
                                    'Cost'          => "1.25 USD",
                                    'Direction'     => 'Outbound',
                                    'Pulse'         => '30',
                                    'Pulses'        => '1',
                                    'PricePerPulse' => '0.7' }
        call_details_list.push call_detail_hash
        call_detail_hash = { 'CallUUID'      => UUID,
                             'Number'        => PHONE_NUMBERS[0],
                             'CallerId'      => 'SMSCountry',
                             'Status'        => 'completed',
                             'RingTime'      => Time.now.to_i.to_s,
                             'AnswerTime'    => Time.now.to_i.to_s,
                             'EndTime'       => Time.now.to_i.to_s,
                             'EndReason'     => 'HANGUP',
                             'Cost'          => "1.25 USD",
                             'Direction'     => 'Outbound',
                             'Pulse'         => '30',
                             'Pulses'        => '1',
                             'PricePerPulse' => '0.7' }
        call_details_list.push call_detail_hash

        stub_request(:get, mock_uri('Calls')).with(query: { 'FromDate' => '2016-09-15 00:00:00' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list }.to_json)

        status, details_list, _, _ = client.call.get_collection(from: Time.new(2016, 9, 15, 0, 0, 0))
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('Calls')).with(query: { 'ToDate' => '2016-09-15 00:00:00' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list }.to_json)

        status, details_list, _, _ = client.call.get_collection(to: Time.new(2016, 9, 15, 0, 0, 0))
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('Calls')).with(query: { 'CallerId' => 'SMSCountry' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list }.to_json)

        status, details_list, _, _ = client.call.get_collection(caller_id: 'SMSCountry')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('Calls')).with(query: { 'Offset' => '5' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list }.to_json)

        status, details_list, _, _ = client.call.get_collection(offset: 5)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('Calls')).with(query: { 'Limit' => '5' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list }.to_json)

        status, details_list, _, _ = client.call.get_collection(limit: 5)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."

    end

    def test_get_collection_next_values

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        call_details_list = []
        call_detail_hash  = { 'CallUUID'      => UUID,
                              'Number'        => PHONE_NUMBERS[0],
                              'CallerId'      => 'SMSCountry',
                              'Status'        => 'completed',
                              'RingTime'      => Time.now.to_i.to_s,
                              'AnswerTime'    => Time.now.to_i.to_s,
                              'EndTime'       => Time.now.to_i.to_s,
                              'EndReason'     => 'NORMAL',
                              'Cost'          => "1.25 USD",
                              'Direction'     => 'Outbound',
                              'Pulse'         => '30',
                              'Pulses'        => '1',
                              'PricePerPulse' => '0.7' }
        call_details_list.push call_detail_hash
        call_detail_hash = { 'CallUUID'      => UUID,
                             'Number'        => PHONE_NUMBERS[0],
                             'CallerId'      => 'SMSCountry',
                             'Status'        => 'completed',
                             'RingTime'      => Time.now.to_i.to_s,
                             'AnswerTime'    => Time.now.to_i.to_s,
                             'EndTime'       => Time.now.to_i.to_s,
                             'EndReason'     => 'HANGUP',
                             'Cost'          => "1.25 USD",
                             'Direction'     => 'Outbound',
                             'Pulse'         => '30',
                             'Pulses'        => '1',
                             'PricePerPulse' => '0.7' }
        call_details_list.push call_detail_hash

        stub_request(:get, mock_uri('Calls'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list,
                                            'Next'    => '/Calls/?Offset=52&Limit=27' }.to_json)

        status, details_list, next_offset, next_limit = client.call.get_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."
        refute_nil next_offset, "Next offset wasn't present."
        assert_equal 52, next_offset, "Next offset value wasn't correct."
        refute_nil next_limit, "Next limit wasn't present."
        assert_equal 27, next_limit, "Next limit value wasn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('Calls'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list,
                                            'Next'    => '/Calls/?Limit=27'}.to_json)

        status, details_list, next_offset, next_limit = client.call.get_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."
        assert_nil next_offset, "Next offset wasn't nil."
        refute_nil next_limit, "Next limit wasn't present."
        assert_equal 27, next_limit, "Next limit value wasn't correct."

        WebMock.reset!

        stub_request(:get, mock_uri('Calls'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list,
                                            'Next'    => '/Calls/?Offset=52'}.to_json)

        status, details_list, next_offset, next_limit = client.call.get_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."
        refute_nil next_offset, "Next offset wasn't present."
        assert_equal 52, next_offset, "Next offset value wasn't correct."
        assert_nil next_limit, "Next limit wasn't nil."

        WebMock.reset!

        stub_request(:get, mock_uri('Calls'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list,
                                            'Next'    => ''}.to_json)

        status, details_list, next_offset, next_limit = client.call.get_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."
        assert_nil next_offset, "Next offset wasn't nil."
        assert_nil next_limit, "Next limit wasn't nil."

        WebMock.reset!

        stub_request(:get, mock_uri('Calls'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => call_details_list }.to_json)

        status, details_list, next_offset, next_limit = client.call.get_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of call detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "NORMAL", details_list[0].end_reason, "First end reason isn't correct."
        assert_equal "HANGUP", details_list[1].end_reason, "Second end reason isn't correct."
        assert_nil next_offset, "Next offset wasn't nil."
        assert_nil next_limit, "Next limit wasn't nil."

    end

    def test_get_collection_no_detail_list

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('Calls'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Calls'   => nil }.to_json)

        status, details_list, _, _ = client.call.get_collection
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "No list of call details included in response.", status.message, "Unexpected message in status."
        assert_nil details_list, "Detail list was not nil."

    end

    def test_get_collection_bad_arguments

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('Calls'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, details_list, _, _ = client.call.get_collection(from: '')
        end

        assert_raises ArgumentError do
            status, details_list, _, _ = client.call.get_collection(to: '')
        end

        assert_raises ArgumentError do
            status, details_list, _, _ = client.call.get_collection(caller_id: 574)
        end

        assert_raises ArgumentError do
            status, details_list, _, _ = client.call.get_collection(offset: '')
        end

        assert_raises ArgumentError do
            status, details_list, _, _ = client.call.get_collection(limit: '')
        end

    end

    def test_get_collection_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('Calls'))
            .to_raise(StandardError)

        status, details_list, _, _ = client.call.get_collection
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil details_list, "Returned detail list was not nil."

    end

    # endregion #get_collection method

    # endregion Call class

end
