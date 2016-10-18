#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require File.expand_path("../../../test_helper", __FILE__)
require 'base64'
require 'webmock/minitest'

class GroupCallTest < Minitest::Test

    # region Recording class

    def test_recording_constructor_and_accessors

        obj = SmsCountryApi::GroupCall::Recording.new
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::Recording, obj, "Object isn't the correct type."
        assert_nil obj.uuid, "UUID isn't nil."
        assert_nil obj.url, "URL isn't nil."

    end

    def test_recording_to_hash

        hash     = { 'RecordingUUID' => UUID, 'Url' => 'none' }
        obj      = SmsCountryApi::GroupCall::Recording.create(UUID, 'none')
        new_hash = obj.to_hash
        refute_nil new_hash, "New hash not created."
        new_hash.each do |k, v|
            assert_equal hash[k], v, "#{k} item did not match."
        end

    end

    def test_recording_create

        obj = SmsCountryApi::GroupCall::Recording.create(UUID, 'none')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::Recording, obj, "Object isn't the correct type."
        assert_equal UUID, obj.uuid, "UUID doesn't match."
        assert_equal 'none', obj.url, "URL doesn't match."

    end

    def test_recording_create_bad_args

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Recording.create(nil, 'none')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Recording.create('', 'none')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Recording.create(754, 'none')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Recording.create(UUID, nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Recording.create(UUID, '')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Recording.create(UUID, 754)
        end

    end

    def test_recording_from_hash

        hash = { 'RecordingUUID' => UUID, 'Url' => 'none' }
        obj  = SmsCountryApi::GroupCall::Recording.from_hash(hash)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::Recording, obj, "Object isn't the correct type."
        assert_equal UUID, obj.uuid, "UUID doesn't match."
        assert_equal 'none', obj.url, "URL doesn't match."

    end

    # endregion Recording class

    # region Participants class

    def test_participant_constructor_and_accessors

        obj = SmsCountryApi::GroupCall::Participant.new
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::Participant, obj, "Object isn't the correct type."
        assert_nil obj.id, "ID isn't nil."
        assert_nil obj.name, "Name isn't nil."
        assert_nil obj.number, "Number isn't nil."
        assert_nil obj.calls, "Call list isn't nil."

    end

    def test_participant_to_hash

        t          = Time.now
        call1_hash = { 'CallUUID'      => UUID,
                       'Number'        => PHONE_NUMBER_1,
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
        call2_hash = { 'CallUUID'      => 'xxx-y-zzzz',
                       'Number'        => '91XXXXXXXXX',
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
        hash       = { 'Id'     => 15,
                       'Name'   => 'somebody',
                       'Number' => "91XXXXXXXXXX",
                       'Calls'  => [call1_hash, call2_hash] }
        call1      = SmsCountryApi::Call::CallDetails.from_hash(call1_hash)
        call2      = SmsCountryApi::Call::CallDetails.from_hash(call2_hash)
        obj        = SmsCountryApi::GroupCall::Participant.create('91XXXXXXXXXX',
                                                                  name:  'somebody',
                                                                  id:    15,
                                                                  calls: [call1, call2])
        new_hash   = obj.to_hash
        refute_nil new_hash, "New hash not created."
        new_hash.each do |k, v|
            if k == 'Calls'
                assert_equal 2, v.length, "Calls list is not the correct length."
                (0..1).each do |i|
                    assert_kind_of Hash, v[i], "Call #{i} isn't the correct type."
                end
            else
                assert_equal hash[k], v, "#{k} item did not match."
            end
        end

    end

    def test_participant_create

        obj = SmsCountryApi::GroupCall::Participant.create('91XXXXXXXXXX')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::Participant, obj, "Object isn't the correct type."
        assert_equal '91XXXXXXXXXX', obj.number, "Number isn't correct."

        obj = SmsCountryApi::GroupCall::Participant.create('91XXXXXXXXXX', name: 'somebody', id: 15)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::Participant, obj, "Object isn't the correct type."
        assert_equal '91XXXXXXXXXX', obj.number, "Number isn't correct."
        assert_equal 'somebody', obj.name, "Name isn't correct."
        assert_equal 15, obj.id, "ID isn't correct."

        t          = Time.now
        call1_hash = { 'CallUUID'      => UUID,
                       'Number'        => PHONE_NUMBER_1,
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
        call2_hash = { 'CallUUID'      => 'xxx-y-zzzz',
                       'Number'        => '91XXXXXXXXX',
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
        call1      = SmsCountryApi::Call::CallDetails.from_hash(call1_hash)
        call2      = SmsCountryApi::Call::CallDetails.from_hash(call2_hash)
        obj        = SmsCountryApi::GroupCall::Participant.create('91XXXXXXXXXX', calls: [call1, call2])
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::Participant, obj, "Object isn't the correct type."
        assert_equal '91XXXXXXXXXX', obj.number, "Number isn't correct."
        assert_equal 2, obj.calls.length, "Call list length isn't correct."

    end

    def test_participant_create_bad_args

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Participant.create(nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Participant.create(754)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Participant.create(PHONE_NUMBER_1, name: 754)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Participant.create(PHONE_NUMBER_1, id: '')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::Participant.create(PHONE_NUMBER_1, calls: '')
        end

    end

    def test_participant_from_hash

        t          = Time.now
        call1_hash = { 'CallUUID'      => UUID,
                       'Number'        => PHONE_NUMBER_1,
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
        call2_hash = { 'CallUUID'      => 'xxx-y-zzzz',
                       'Number'        => '91XXXXXXXXX',
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
        hash       = { 'Id'     => 15,
                       'Name'   => 'somebody',
                       'Number' => "91XXXXXXXXXX",
                       'Calls'  => [call1_hash, call2_hash] }
        obj        = SmsCountryApi::GroupCall::Participant.from_hash(hash)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::Participant, obj, "Object isn't the correct type."
        assert_equal '91XXXXXXXXXX', obj.number, "Number isn't correct."
        assert_equal 'somebody', obj.name, "Name isn't correct."
        assert_equal 15, obj.id, "ID isn't correct."
        assert_equal 2, obj.calls.length, "Calls list is not the correct length."
        (0..1).each do |i|
            assert_kind_of SmsCountryApi::Call::CallDetails, obj.calls[i], "Call #{i} isn't the correct type."
        end

    end

    # endregion Participant class

    # region GroupCallDetails class

    def test_groupcalldetail_constructor_and_accessors

        obj = SmsCountryApi::GroupCall::GroupCallDetails.new
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::GroupCallDetails, obj, "Object isn't the correct type."
        assert_nil obj.uuid, "UUID isn't nil."
        assert_nil obj.name, "Name isn't nil."
        assert_nil obj.welcome_sound, "Welcome sound isn't nil."
        assert_nil obj.wait_sound, "Wait sound isn't nil."
        assert_nil obj.start_call_on_enter, "Start call on enter isn't nil."
        assert_nil obj.end_call_on_exit, "End call on exit isn't nil."
        assert_nil obj.participants, "Participants list isn't nil."

    end

    def test_groupcalldetail_to_hash

        t                 = Time.now
        call1_hash        = { 'CallUUID'      => UUID,
                              'Number'        => PHONE_NUMBER_1,
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
        call2_hash        = { 'CallUUID'      => 'xxx-y-zzzz',
                              'Number'        => '91XXXXXXXXX',
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
        participant1_hash = { 'Id'     => 15,
                              'Name'   => 'somebody',
                              'Number' => "91XXXXXXXXXX",
                              'Calls'  => [call1_hash, call2_hash] }
        participant2_hash = { 'Id'     => 29,
                              'Name'   => 'nobody',
                              'Number' => "91XXXXXXYYYY",
                              'Calls'  => [call1_hash, call2_hash] }
        participant1      = SmsCountryApi::GroupCall::Participant.from_hash(participant1_hash)
        participant2      = SmsCountryApi::GroupCall::Participant.from_hash(participant2_hash)
        hash              = { 'GroupCallUUID'         => UUID,
                              'Name'                  => 'group call 1',
                              'WelcomeSound'          => 'welcome',
                              'WaitSound'             => 'wait',
                              'StartGroupCallOnEnter' => 'enter',
                              'EndGroupCallOnExit'    => 'exit',
                              'Participants'          => [participant1_hash, participant2_hash] }
        obj               = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID,
                                                                              name:                'group call 1',
                                                                              welcome_sound:       'welcome',
                                                                              wait_sound:          'wait',
                                                                              start_call_on_enter: 'enter',
                                                                              end_call_on_exit:    'exit',
                                                                              participants:        [participant1,
                                                                                                    participant2])
        new_hash          = obj.to_hash
        refute_nil new_hash, "New hash not created."
        new_hash.each do |k, v|
            if k == 'Participants'
                assert_equal 2, v.length, "Participants list is not the correct length."
                (0..1).each do |i|
                    assert_kind_of Hash, v[i], "Participant #{i} isn't the correct type."
                end
            else
                assert_equal hash[k], v, "#{k} item did not match."
            end
        end

    end

    def test_groupcalldetail_create

        obj = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::GroupCallDetails, obj, "Object isn't the correct type."
        assert_equal UUID, obj.uuid, "UUID isn't correct."

        t                 = Time.now
        call1_hash        = { 'CallUUID'      => UUID,
                              'Number'        => PHONE_NUMBER_1,
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
        call2_hash        = { 'CallUUID'      => 'xxx-y-zzzz',
                              'Number'        => '91XXXXXXXXX',
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
        participant1_hash = { 'Id'     => 15,
                              'Name'   => 'somebody',
                              'Number' => "91XXXXXXXXXX",
                              'Calls'  => [call1_hash, call2_hash] }
        participant2_hash = { 'Id'     => 29,
                              'Name'   => 'nobody',
                              'Number' => "91XXXXXXYYYY",
                              'Calls'  => [call1_hash, call2_hash] }
        participant1      = SmsCountryApi::GroupCall::Participant.from_hash(participant1_hash)
        participant2      = SmsCountryApi::GroupCall::Participant.from_hash(participant2_hash)
        obj               = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID,
                                                                              name:                'group call 1',
                                                                              welcome_sound:       'welcome',
                                                                              wait_sound:          'wait',
                                                                              start_call_on_enter: 'enter',
                                                                              end_call_on_exit:    'exit',
                                                                              participants:        [participant1,
                                                                                                    participant2])
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::GroupCall::GroupCallDetails, obj, "Object isn't the correct type."
        assert_equal UUID, obj.uuid, "UUID doesn't match."
        assert_equal 'group call 1', obj.name, "Name doesn't match."
        assert_equal 'welcome', obj.welcome_sound, "Welcome sound doesn't match."
        assert_equal 'wait', obj.wait_sound, "Wait sound doesn't match."
        assert_equal 'enter', obj.start_call_on_enter, "Start call on enter doesn't match."
        assert_equal 'exit', obj.end_call_on_exit, "End call on exit doesn't match."
        assert_equal 2, obj.participants.length, "Participants list length doesn't match."
        (0..1).each do |i|
            assert_kind_of SmsCountryApi::GroupCall::Participant, obj.participants[i], "Participant #{i} isn't the right type."
        end

    end

    def test_groupcalldetail_create_bad_args

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create(nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create('')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create(754)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID, name: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID, welcome_sound: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID, wait_sound: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID, start_call_on_enter: 754)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID, end_call_on_exit: 754)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.create(UUID, participants: '')
        end

    end

    def test_groupcalldetail_from_hash

        t                 = Time.now
        call1_hash        = { 'CallUUID'      => UUID,
                              'Number'        => PHONE_NUMBER_1,
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
        call2_hash        = { 'CallUUID'      => 'xxx-y-zzzz',
                              'Number'        => '91XXXXXXXXX',
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
        participant1_hash = { 'Id'     => 15,
                              'Name'   => 'somebody',
                              'Number' => "91XXXXXXXXXX",
                              'Calls'  => [call1_hash, call2_hash] }
        participant2_hash = { 'Id'     => 29,
                              'Name'   => 'nobody',
                              'Number' => "91XXXXXXYYYY",
                              'Calls'  => [call1_hash, call2_hash] }
        hash              = { 'GroupCallUUID'         => UUID,
                              'Name'                  => 'group call 1',
                              'WelcomeSound'          => 'welcome',
                              'WaitSound'             => 'wait',
                              'StartGroupCallOnEnter' => 'enter',
                              'EndGroupCallOnExit'    => 'exit',
                              'Participants'          => [participant1_hash, participant2_hash] }
        obj               = SmsCountryApi::GroupCall::GroupCallDetails.from_hash(hash)
        assert_equal UUID, obj.uuid, "UUID doesn't match."
        assert_equal 'group call 1', obj.name, "Name doesn't match."
        assert_equal 'welcome', obj.welcome_sound, "Welcome sound doesn't match."
        assert_equal 'wait', obj.wait_sound, "Wait sound doesn't match."
        assert_equal 'enter', obj.start_call_on_enter, "Start call on enter doesn't match."
        assert_equal 'exit', obj.end_call_on_exit, "End call on exit doesn't match."
        assert_equal 2, obj.participants.length, "Participants list length doesn't match."
        (0..1).each do |i|
            assert_kind_of SmsCountryApi::GroupCall::Participant, obj.participants[i], "Participant #{i} isn't the right type."
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.from_hash(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall::GroupCallDetails.from_hash('')
        end

    end

    # endregion GroupCallDetails class

    # region GroupCall class

    def test_constructor

        endpoint = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy")
        refute_nil endpoint, "Endpoint was not successfully created."
        obj = SmsCountryApi::GroupCall.new(endpoint)
        refute_nil obj, "GroupCall object was not successfully created."
        assert_kind_of SmsCountryApi::GroupCall, obj, "GroupCall object isn't the right type."

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall.new(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::GroupCall.new("Non-endpoint")
        end

    end

    # region #initiate_group_call

    def test_initiate_group_call_basic_success

        participant1_hash = { 'Name'   => 'somebody',
                              'Number' => "91XXXXXXXXXX" }
        participant2_hash = { 'Name'   => 'nobody',
                              'Number' => "91XXXXXXYYYY" }
        participant1      = SmsCountryApi::GroupCall::Participant.from_hash(participant1_hash)
        participant2      = SmsCountryApi::GroupCall::Participant.from_hash(participant2_hash)

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls'))
            .to_return(status: 202, body: { 'Success'   => true,
                                            'Message'   => "Operation succeeded",
                                            'ApiId'     => API_ID,
                                            'GroupCall' => { 'GroupCallUUID' => UUID,
                                                             'Participants'  => [{ 'Name'   => 'somebody',
                                                                                   'Number' => '91XXXXXXXXXX' },
                                                                                 { 'Name'   => 'nobody',
                                                                                   'Number' => '91XXXXXXYYYY' }] } }.to_json)

        status, group_call = client.group_call.initiate_group_call('group call 1', [participant1, participant2])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil group_call, "No group call details returned."
        assert_equal UUID, group_call.uuid, "UUID doesn't match."
        assert_equal 2, group_call.participants.length, "Participants list length doesn't match."
        (0..1).each do |i|
            assert_kind_of SmsCountryApi::GroupCall::Participant, group_call.participants[i], "Participant #{i} not the right type."
        end

    end

    def test_initiate_group_call_optional_args

        participant1_hash = { 'Name'   => 'somebody',
                              'Number' => "91XXXXXXXXXX" }
        participant2_hash = { 'Name'   => 'nobody',
                              'Number' => "91XXXXXXYYYY" }
        participant1      = SmsCountryApi::GroupCall::Participant.from_hash(participant1_hash)
        participant2      = SmsCountryApi::GroupCall::Participant.from_hash(participant2_hash)

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls'))
            .to_return(status: 202, body: { 'Success'   => true,
                                            'Message'   => "Operation succeeded",
                                            'ApiId'     => API_ID,
                                            'GroupCall' => { 'GroupCallUUID' => UUID,
                                                             'Participants'  => [{ 'Name'   => 'somebody',
                                                                                   'Number' => '91XXXXXXXXXX' },
                                                                                 { 'Name'   => 'nobody',
                                                                                   'Number' => '91XXXXXXYYYY' }] } }.to_json)

        status, group_call = client.group_call.initiate_group_call('group call 1', [participant1, participant2],
                                                                   welcome_sound:       'welcome',
                                                                   wait_sound:          'wait',
                                                                   start_call_on_enter: 'enter',
                                                                   end_call_on_exit:    'exit')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil group_call, "No group call details returned."
        assert_equal UUID, group_call.uuid, "UUID doesn't match."
        assert_equal 2, group_call.participants.length, "Participants list length doesn't match."
        (0..1).each do |i|
            assert_kind_of SmsCountryApi::GroupCall::Participant, group_call.participants[i], "Participant #{i} not the right type."
        end

    end

    def test_initiate_group_call_bad_args

        participant1_hash = { 'Name'   => 'somebody',
                              'Number' => "91XXXXXXXXXX" }
        participant2_hash = { 'Name'   => 'nobody',
                              'Number' => "91XXXXXXYYYY" }
        participant1      = SmsCountryApi::GroupCall::Participant.from_hash(participant1_hash)
        participant2      = SmsCountryApi::GroupCall::Participant.from_hash(participant2_hash)

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call(nil, [participant1, participant2],
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    'exit')
        end
        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call('', [participant1, participant2],
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    'exit')
        end
        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call(754, [participant1, participant2],
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    'exit')
        end

        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call('group call 1', nil,
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    'exit')
        end
        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call('group call 1', [],
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    'exit')
        end
        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call('group call 1', '',
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    'exit')
        end

        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call('group call 1', [participant1, participant2],
                                                                       welcome_sound:       754,
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    'exit')
        end
        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call('group call 1', [participant1, participant2],
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          754,
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    'exit')
        end
        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call('group call 1', [participant1, participant2],
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 754,
                                                                       end_call_on_exit:    'exit')
        end
        assert_raises ArgumentError do
            status, group_call = client.group_call.initiate_group_call('group call 1', [participant1, participant2],
                                                                       welcome_sound:       'welcome',
                                                                       wait_sound:          'wait',
                                                                       start_call_on_enter: 'enter',
                                                                       end_call_on_exit:    754)
        end

    end

    def test_initiate_group_call_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        participant1_hash = { 'Name'   => 'somebody',
                              'Number' => "91XXXXXXXXXX" }
        participant2_hash = { 'Name'   => 'nobody',
                              'Number' => "91XXXXXXYYYY" }
        participant1      = SmsCountryApi::GroupCall::Participant.from_hash(participant1_hash)
        participant2      = SmsCountryApi::GroupCall::Participant.from_hash(participant2_hash)

        stub_request(:post, mock_uri('GroupCalls'))
            .to_raise(StandardError)

        status, group_call = client.group_call.initiate_group_call('group call 1', [participant1, participant2])
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil group_call, "Returned group call detail was not nil."

    end

    # endregion #initiate_group_call

    # region #get_group_call_details

    def test_get_group_call_details_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID))
            .to_return(status: 200, body: { 'Success'   => true,
                                            'Message'   => "Operation succeeded",
                                            'ApiId'     => API_ID,
                                            'GroupCall' => { 'GroupCallUUID'         => UUID,
                                                             'Name'                  => 'group call 1',
                                                             'WelcomeSound'          => 'welcome',
                                                             'WaitSound'             => 'wait',
                                                             'StartGroupCallOnEnter' => 'enter',
                                                             'EndGroupCallOnExit'    => 'exit' } }.to_json)

        status, details = client.group_call.get_group_call_details(UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details, "No group call details returned."
        assert_equal UUID, details.uuid, "UUID doesn't match."
        assert_equal 'group call 1', details.name, "Name doesn't match."
        assert_equal 'welcome', details.welcome_sound, "Welcome sound doesn't match."
        assert_equal 'wait', details.wait_sound, "Wait sound doesn't match."
        assert_equal 'enter', details.start_call_on_enter, "Start call on enter doesn't match."
        assert_equal 'exit', details.end_call_on_exit, "End call on exit doesn't match."

    end

    def test_get_group_call_details_bad_uuid

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID))
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, details = client.group_call.get_group_call_details(nil)
        end

        assert_raises ArgumentError do
            status, details = client.group_call.get_group_call_details('')
        end

        assert_raises ArgumentError do
            status, details = client.group_call.get_group_call_details(754)
        end

    end

    def test_get_group_call_details_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID))
            .to_raise(StandardError)

        status, details = client.group_call.get_group_call_details(UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil details, "Returned group call detail was not nil."

    end

    # endregion #get_group_call_details

    # region #get_group_call_collection

    def test_get_group_call_collection_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls'))
            .to_return(status: 200, body: { 'Success'    => true,
                                            'Message'    => "Operation succeeded",
                                            'ApiId'      => API_ID,
                                            'GroupCalls' => [{ 'GroupCallUUID'         => UUID,
                                                               'Name'                  => 'group call 1',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' },
                                                             { 'GroupCallUUID'         => 'xxx-y-zzzz',
                                                               'Name'                  => 'group call 2',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' }] }.to_json)

        status, detail_list = client.group_call.get_group_call_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil detail_list, "No group call detail list returned."
        assert_equal 2, detail_list.length, "Group call detail list length incorrect."
        assert_equal UUID, detail_list[0].uuid, "Group call 1 UUID doesn't match."
        assert_equal 'xxx-y-zzzz', detail_list[1].uuid, "Group call 2 UUID doesn't match."

    end

    def test_get_group_call_collection_filters

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls')).with(query: { 'FromDate' => '2016-09-15 00:00:00' })
            .to_return(status: 200, body: { 'Success'    => true,
                                            'Message'    => "Operation succeeded",
                                            'ApiId'      => API_ID,
                                            'GroupCalls' => [{ 'GroupCallUUID'         => UUID,
                                                               'Name'                  => 'group call 1',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' },
                                                             { 'GroupCallUUID'         => 'xxx-y-zzzz',
                                                               'Name'                  => 'group call 2',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' }] }.to_json)

        status, detail_list = client.group_call.get_group_call_collection(from: Time.new(2016, 9, 15, 0, 0, 0))
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil detail_list, "No group call detail list returned."
        assert_equal 2, detail_list.length, "Group call detail list length incorrect."
        assert_equal UUID, detail_list[0].uuid, "Group call 1 UUID doesn't match."
        assert_equal 'xxx-y-zzzz', detail_list[1].uuid, "Group call 2 UUID doesn't match."

        WebMock.reset!

        stub_request(:get, mock_uri('GroupCalls')).with(query: { 'ToDate' => '2016-09-15 00:00:00' })
            .to_return(status: 200, body: { 'Success'    => true,
                                            'Message'    => "Operation succeeded",
                                            'ApiId'      => API_ID,
                                            'GroupCalls' => [{ 'GroupCallUUID'         => UUID,
                                                               'Name'                  => 'group call 1',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' },
                                                             { 'GroupCallUUID'         => 'xxx-y-zzzz',
                                                               'Name'                  => 'group call 2',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' }] }.to_json)

        status, detail_list = client.group_call.get_group_call_collection(to: Time.new(2016, 9, 15, 0, 0, 0))
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil detail_list, "No group call detail list returned."
        assert_equal 2, detail_list.length, "Group call detail list length incorrect."
        assert_equal UUID, detail_list[0].uuid, "Group call 1 UUID doesn't match."
        assert_equal 'xxx-y-zzzz', detail_list[1].uuid, "Group call 2 UUID doesn't match."

        WebMock.reset!

        stub_request(:get, mock_uri('GroupCalls')).with(query: { 'Offset' => '5' })
            .to_return(status: 200, body: { 'Success'    => true,
                                            'Message'    => "Operation succeeded",
                                            'ApiId'      => API_ID,
                                            'GroupCalls' => [{ 'GroupCallUUID'         => UUID,
                                                               'Name'                  => 'group call 1',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' },
                                                             { 'GroupCallUUID'         => 'xxx-y-zzzz',
                                                               'Name'                  => 'group call 2',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' }] }.to_json)

        status, detail_list = client.group_call.get_group_call_collection(offset: 5)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil detail_list, "No group call detail list returned."
        assert_equal 2, detail_list.length, "Group call detail list length incorrect."
        assert_equal UUID, detail_list[0].uuid, "Group call 1 UUID doesn't match."
        assert_equal 'xxx-y-zzzz', detail_list[1].uuid, "Group call 2 UUID doesn't match."

        WebMock.reset!

        stub_request(:get, mock_uri('GroupCalls')).with(query: { 'Limit' => '8' })
            .to_return(status: 200, body: { 'Success'    => true,
                                            'Message'    => "Operation succeeded",
                                            'ApiId'      => API_ID,
                                            'GroupCalls' => [{ 'GroupCallUUID'         => UUID,
                                                               'Name'                  => 'group call 1',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' },
                                                             { 'GroupCallUUID'         => 'xxx-y-zzzz',
                                                               'Name'                  => 'group call 2',
                                                               'WelcomeSound'          => 'welcome',
                                                               'WaitSound'             => 'wait',
                                                               'StartGroupCallOnEnter' => 'enter',
                                                               'EndGroupCallOnExit'    => 'exit' }] }.to_json)

        status, detail_list = client.group_call.get_group_call_collection(limit: 8)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil detail_list, "No group call detail list returned."
        assert_equal 2, detail_list.length, "Group call detail list length incorrect."
        assert_equal UUID, detail_list[0].uuid, "Group call 1 UUID doesn't match."
        assert_equal 'xxx-y-zzzz', detail_list[1].uuid, "Group call 2 UUID doesn't match."

    end

    def test_get_group_call_collection_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls'))
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, detail_list = client.group_call.get_group_call_collection(from: '')
        end

        assert_raises ArgumentError do
            status, detail_list = client.group_call.get_group_call_collection(to: '')
        end

        assert_raises ArgumentError do
            status, detail_list = client.group_call.get_group_call_collection(offset: '')
        end
        assert_raises ArgumentError do
            status, detail_list = client.group_call.get_group_call_collection(limit: '')
        end

    end

    def test_get_group_call_collection_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls'))
            .to_raise(StandardError)

        status, detail_list = client.group_call.get_group_call_collection
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil detail_list, "Returned group call detail list was not nil."

    end

    # endregion #get_group_call_collection

    # region #get_participant

    def test_get_participant_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Participants', '15'))
            .to_return(status: 200, body: { 'Success'     => true,
                                            'Message'     => "Operation succeeded",
                                            'ApiId'       => API_ID,
                                            'Participant' => { 'Id'     => 15,
                                                               'Name'   => 'somebody',
                                                               'Number' => PHONE_NUMBER_1 } }.to_json)

        status, participant = client.group_call.get_participant(UUID, 15)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil participant, "No participant returned."
        assert_equal 15, participant.id, "ID doesn't match."
        assert_equal 'somebody', participant.name, "Name doesn't match."
        assert_equal PHONE_NUMBER_1, participant.number, "Number doesn't match."

    end

    def test_get_participant_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Participants', '15'))
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, participant = client.group_call.get_participant(nil, 15)
        end
        assert_raises ArgumentError do
            status, participant = client.group_call.get_participant('', 15)
        end
        assert_raises ArgumentError do
            status, participant = client.group_call.get_participant(754, 15)
        end

        assert_raises ArgumentError do
            status, participant = client.group_call.get_participant(UUID, nil)
        end
        assert_raises ArgumentError do
            status, participant = client.group_call.get_participant(UUID, '')
        end

    end

    def test_get_participant_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Participants', '15'))
            .to_raise(StandardError)

        status, participant = client.group_call.get_participant(UUID, 15)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil participant, "Returned participant was not nil."

    end

    # endregion #get_participant

    # region #get_participants

    def test_get_participants_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Participants'))
            .to_return(status: 200, body: { 'Success'      => true,
                                            'Message'      => "Operation succeeded",
                                            'ApiId'        => API_ID,
                                            'Participants' => [{ 'Id'     => 15,
                                                                 'Name'   => 'somebody',
                                                                 'Number' => PHONE_NUMBER_1 },
                                                               { 'Id'     => 29,
                                                                 'Name'   => 'nobody',
                                                                 'Number' => "91XXXXXXYYYY" }] }.to_json)

        status, participants = client.group_call.get_participants(UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil participants, "No participant list returned."
        assert_equal 2, participants.length, "Participant list length isn't correct."
        assert_equal 15, participants[0].id, "Participant 1 ID doesn't match."
        assert_equal 'somebody', participants[0].name, "Participant 1 name doesn't match."
        assert_equal PHONE_NUMBER_1, participants[0].number, "Participant 1 number doesn't match."
        assert_equal 29, participants[1].id, "Participant 2 ID doesn't match."
        assert_equal 'nobody', participants[1].name, "Participant 2 name doesn't match."
        assert_equal '91XXXXXXYYYY', participants[1].number, "Participant 2 number doesn't match."

    end

    def test_get_participants_bad_arg

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Participants'))
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, participants = client.group_call.get_participants(nil)
        end
        assert_raises ArgumentError do
            status, participants = client.group_call.get_participants('')
        end
        assert_raises ArgumentError do
            status, participants = client.group_call.get_participants(754)
        end

    end

    def test_get_participants_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Participants'))
            .to_raise(StandardError)

        status, participants = client.group_call.get_participants(UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil participants, "Returned participant list was not nil."

    end

    # endregion #get_participants

    # region #terminate_group_call

    def test_terminate_group_call_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Hangup'))
            .to_return(status: 202, body: { 'Success'                => true,
                                            'Message'                => "Operation succeeded",
                                            'ApiId'                  => API_ID,
                                            'AffectedParticipantIds' => [15, 29] }.to_json)

        status, participants = client.group_call.terminate_group_call(UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil participants, "No participant list returned."
        assert_equal 2, participants.length, "Participant list length isn't correct."
        participants.each do |p|
            assert_kind_of Numeric, p, "Participant illegal type."
        end
        assert_equal 15, participants[0], "Participant 1 doesn't match."
        assert_equal 29, participants[1], "Participant 2 doesn't match"

    end

    def test_terminate_group_call_bad_arg

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Hangup'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, participants = client.group_call.terminate_group_call(nil)
        end
        assert_raises ArgumentError do
            status, participants = client.group_call.terminate_group_call('')
        end
        assert_raises ArgumentError do
            status, participants = client.group_call.terminate_group_call(754)
        end

    end

    def test_terminate_group_call_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Hangup'))
            .to_raise(StandardError)

        status, participants = client.group_call.terminate_group_call(UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil participants, "Returned affected participant list was not nil."

    end

    # endregion #terminate_group_call

    # region #terminate_participant

    def test_terminate_participant_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Hangup'))
            .to_return(status: 202, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, = client.group_call.terminate_participant(UUID, 15)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message

    end

    def test_terminate_participant_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Hangup'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, = client.group_call.terminate_participant(nil, 15)
        end
        assert_raises ArgumentError do
            status, = client.group_call.terminate_participant('', 15)
        end
        assert_raises ArgumentError do
            status, = client.group_call.terminate_participant(754, 15)
        end

        assert_raises ArgumentError do
            status, = client.group_call.terminate_participant(UUID, nil)
        end
        assert_raises ArgumentError do
            status, = client.group_call.terminate_participant(UUID, '')
        end

    end

    def test_terminate_participant_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Hangup'))
            .to_raise(StandardError)

        status, = client.group_call.terminate_participant(UUID, 15)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #terminate_participant

    # region #play_sound_into_call

    def test_play_sound_into_call_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Play'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)
        stub_request(:post, mock_uri('GroupCalls', UUID, 'Play'))
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, = client.group_call.play_sound_into_call(UUID, 15, 'test url')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message

        status, = client.group_call.play_sound_into_call(UUID, nil, 'test url')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message

    end

    def test_play_sound_into_call_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Play'))
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)
        stub_request(:post, mock_uri('GroupCalls', UUID, 'Play'))
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, = client.group_call.play_sound_into_call(nil, 15, 'test url')
        end
        assert_raises ArgumentError do
            status, = client.group_call.play_sound_into_call('', 15, 'test url')
        end
        assert_raises ArgumentError do
            status, = client.group_call.play_sound_into_call(754, 15, 'test url')
        end

        assert_raises ArgumentError do
            status, = client.group_call.play_sound_into_call(UUID, '', 'test url')
        end

        assert_raises ArgumentError do
            status, = client.group_call.play_sound_into_call(UUID, 15, nil)
        end
        assert_raises ArgumentError do
            status, = client.group_call.play_sound_into_call(UUID, 15, '')
        end
        assert_raises ArgumentError do
            status, = client.group_call.play_sound_into_call(UUID, 15, 754)
        end

    end

    def test_play_sound_into_call_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Play'))
            .to_raise(StandardError)
        stub_request(:post, mock_uri('GroupCalls', UUID, 'Play'))
            .to_raise(StandardError)

        status, = client.group_call.play_sound_into_call(UUID, 15, 'test url')
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

        status, = client.group_call.play_sound_into_call(UUID, nil, 'test url')
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #play_sound_into_call

    # region #mute_participants

    def test_mute_participant_single_participant

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Mute'))
            .to_return(status: 202, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, failed_participants = client.group_call.mute_participant(UUID, 15)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        assert_nil failed_participants, 'Failed participant list is non-nil.'

    end

    def test_mute_participant_all_participants

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Mute'))
            .to_return(status: 202, body: { 'Success'              => true,
                                            'Message'              => "Operation succeeded",
                                            'ApiId'                => API_ID,
                                            'FailedParticipantIds' => [17, 47] }.to_json)

        status, failed_participants = client.group_call.mute_participant(UUID, nil)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil failed_participants, 'Failed participant list is nil.'
        assert_equal 2, failed_participants.length, "Failed participants list length is incorrect."
        failed_participants.each do |p|
            assert_kind_of Numeric, p, "Failed participant wrong type."
        end

    end

    def test_mute_participant_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Mute'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, failed_participants = client.group_call.mute_participant(nil, 15)
        end
        assert_raises ArgumentError do
            status, failed_participants = client.group_call.mute_participant('', 15)
        end
        assert_raises ArgumentError do
            status, failed_participants = client.group_call.mute_participant(754, 15)
        end

        assert_raises ArgumentError do
            status, failed_participants = client.group_call.mute_participant(UUID, '')
        end

    end

    def test_mute_participant_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'Mute'))
            .to_raise(StandardError)
        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Mute'))
            .to_raise(StandardError)

        status, failed_participants = client.group_call.mute_participant(UUID, 15)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

        status, failed_participants = client.group_call.mute_participant(UUID, nil)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #mute_participants

    # region #unmute_participants

    def test_unmute_participant_single_participant

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'UnMute'))
            .to_return(status: 202, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, failed_participants = client.group_call.unmute_participant(UUID, 15)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        assert_nil failed_participants, 'Failed participant list is non-nil.'

    end

    def test_unmute_participant_all_participants

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'UnMute'))
            .to_return(status: 202, body: { 'Success'              => true,
                                            'Message'              => "Operation succeeded",
                                            'ApiId'                => API_ID,
                                            'FailedParticipantIds' => [17, 47] }.to_json)

        status, failed_participants = client.group_call.unmute_participant(UUID, nil)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil failed_participants, 'Failed participant list is nil.'
        assert_equal 2, failed_participants.length, "Failed participants list length is incorrect."
        failed_participants.each do |p|
            assert_kind_of Numeric, p, "Failed participant wrong type."
        end

    end

    47/85

    def test_unmute_participant_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'UnMute'))
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, failed_participants = client.group_call.unmute_participant(nil, 15)
        end
        assert_raises ArgumentError do
            status, failed_participants = client.group_call.unmute_participant('', 15)
        end
        assert_raises ArgumentError do
            status, failed_participants = client.group_call.unmute_participant(754, 15)
        end

        assert_raises ArgumentError do
            status, failed_participants = client.group_call.unmute_participant(UUID, '')
        end

    end

    def test_unmute_participant_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Participants', '15', 'UnMute'))
            .to_raise(StandardError)
        stub_request(:patch, mock_uri('GroupCalls', UUID, 'UnMute'))
            .to_raise(StandardError)

        status, failed_participants = client.group_call.unmute_participant(UUID, 15)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

        status, failed_participants = client.group_call.unmute_participant(UUID, nil)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #unmute_participants

    # region #start_recording

    def test_start_recording_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls', UUID, 'Recordings'))
            .to_return(status: 201, body: { 'Success'   => true,
                                            'Message'   => "Operation succeeded",
                                            'ApiId'     => API_ID,
                                            'Recording' => { 'RecordingUUID' => UUID,
                                                             'Url'           => 'none' } }.to_json)

        status, recording = client.group_call.start_recording(UUID, 'mp3')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil recording, "No recording object returned."
        assert_equal UUID, recording.uuid, "UUID doesn't match."
        assert_equal 'none', recording.url, "URL doesn't match."

    end

    def test_start_recording_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls', UUID, 'Recordings'))
            .to_return(status: 201, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, recording = client.group_call.start_recording(nil, 'mp3')
        end
        assert_raises ArgumentError do
            status, recording = client.group_call.start_recording('', 'mp3')
        end
        assert_raises ArgumentError do
            status, recording = client.group_call.start_recording(754, 'mp3')
        end

        assert_raises ArgumentError do
            status, recording = client.group_call.start_recording(UUID, nil)
        end
        assert_raises ArgumentError do
            status, recording = client.group_call.start_recording(UUID, '')
        end
        assert_raises ArgumentError do
            status, recording = client.group_call.start_recording(UUID, 754)
        end

    end

    def test_start_recording_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, mock_uri('GroupCalls', UUID, 'Recordings'))
            .to_raise(StandardError)

        status, recording = client.group_call.start_recording(UUID, 'mp3')
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil recording, "Recording was not nil."

    end

    # endregion #start_recording

    # region #stop_recording

    def test_stop_recording_single_recording

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_return(status: 201, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, affected_recordings = client.group_call.stop_recording(UUID, UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        assert_nil affected_recordings, "Affected recording list was not nil."

    end

    def test_stop_recording_all_recordings

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Recordings'))
            .to_return(status: 201, body: { 'Success'                => true,
                                            'Message'                => "Operation succeeded",
                                            'ApiId'                  => API_ID,
                                            'AffectedRecordingUUIDs' => [UUID, 'xxx-y-zzzz'] }.to_json)

        status, affected_recordings = client.group_call.stop_recording(UUID, nil)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        assert_equal 2, affected_recordings.length, "Affected recording list length not correct."
        assert_equal UUID, affected_recordings[0], "First recording UUID doesn't match."
        assert_equal 'xxx-y-zzzz', affected_recordings[1], "Second recording UUID doesn't match."

    end

    def test_stop_recording_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_return(status: 201, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, affected_recordings = client.group_call.stop_recording(nil, UUID)
        end
        assert_raises ArgumentError do
            status, affected_recordings = client.group_call.stop_recording('', UUID)
        end
        assert_raises ArgumentError do
            status, affected_recordings = client.group_call.stop_recording(754, UUID)
        end

        assert_raises ArgumentError do
            status, affected_recordings = client.group_call.stop_recording(UUID, '')
        end
        assert_raises ArgumentError do
            status, affected_recordings = client.group_call.stop_recording(UUID, 754)
        end

    end

    def test_stop_recording_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_raise(StandardError)

        status, affected_recordings = client.group_call.stop_recording(UUID, UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil affected_recordings, "Affected recording list was not nil."

    end

    # endregion #stop_recording

    # region #get_recording_details

    def test_get_recording_details_single_recording

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_return(status: 200, body: { 'Success'   => true,
                                            'Message'   => "Operation succeeded",
                                            'ApiId'     => API_ID,
                                            'Recording' => { 'RecordingUUID' => UUID,
                                                             'Url'           => 'none' } }.to_json)

        status, recording = client.group_call.get_recording_details(UUID, UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil recording, "No recording object returned."
        assert_equal UUID, recording.uuid, "UUID doesn't match."
        assert_equal 'none', recording.url, "URL doesn't match."

    end

    def test_get_recording_details_all_recordings

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Recordings'))
            .to_return(status: 200, body: { 'Success'    => true,
                                            'Message'    => "Operation succeeded",
                                            'ApiId'      => API_ID,
                                            'Recordings' => [{ 'RecordingUUID' => UUID,
                                                               'Url'           => 'none' },
                                                             { 'RecordingUUID' => 'xxx-y-zzzz',
                                                               'Url'           => 'bogus' }] }.to_json)

        status, recordings = client.group_call.get_recording_details(UUID, nil)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        assert_equal 2, recordings.length, "Recording list length incorrect."
        assert_equal UUID, recordings[0].uuid, "First recording UUID doesn't match."
        assert_equal 'none', recordings[0].url, "First recording URL doesn't match."
        assert_equal 'xxx-y-zzzz', recordings[1].uuid, "Second recording UUID doesn't match."
        assert_equal 'bogus', recordings[1].url, "Second recording URL doesn't match."

    end

    def test_get_recording_details_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, recording = client.group_call.get_recording_details(nil, UUID)
        end
        assert_raises ArgumentError do
            status, recording = client.group_call.get_recording_details('', UUID)
        end
        assert_raises ArgumentError do
            status, recording = client.group_call.get_recording_details(754, UUID)
        end

        assert_raises ArgumentError do
            status, recording = client.group_call.get_recording_details(UUID, '')
        end
        assert_raises ArgumentError do
            status, recording = client.group_call.get_recording_details(UUID, 754)
        end

    end

    def test_get_recording_details_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_raise(StandardError)
        stub_request(:get, mock_uri('GroupCalls', UUID, 'Recordings'))
            .to_raise(StandardError)

        status, recording = client.group_call.get_recording_details(UUID, UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil recording, "Recording was not nil."

        status, recording = client.group_call.get_recording_details(UUID, nil)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil recording, "Recording was not nil."

    end


    # endregion #get_recording_details

    # region #delete_recording

    def test_delete_recording_single_recording

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_return(status: 204)

        status, = client.group_call.delete_recording(UUID, UUID)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s

    end

    def test_delete_recording_all_recordings

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, mock_uri('GroupCalls', UUID, 'Recordings'))
            .to_return(status: 204)

        status, = client.group_call.delete_recording(UUID, nil)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s

    end


    def test_delete_recording_bad_args

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_return(status: 204)

        assert_raises ArgumentError do
            status, = client.group_call.delete_recording(nil, UUID)
        end
        assert_raises ArgumentError do
            status, = client.group_call.delete_recording('', UUID)
        end
        assert_raises ArgumentError do
            status, = client.group_call.delete_recording(754, UUID)
        end

        assert_raises ArgumentError do
            status, = client.group_call.delete_recording(UUID, '')
        end
        assert_raises ArgumentError do
            status, = client.group_call.delete_recording(UUID, 754)
        end

    end

    def test_delete_recording_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, mock_uri('GroupCalls', UUID, 'Recordings', UUID))
            .to_raise(StandardError)
        stub_request(:delete, mock_uri('GroupCalls', UUID, 'Recordings'))
            .to_raise(StandardError)

        status, = client.group_call.delete_recording(UUID, UUID)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

        status, = client.group_call.delete_recording(UUID, nil)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #delete_recording

    # endregion GroupCall class

end
