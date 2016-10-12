#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require File.expand_path("../../test_helper", __FILE__)
require 'base64'
require 'webmock/minitest'

class GroupTest < Minitest::Test

    # region Member class

    def test_member_constructor_and_accessors

        obj = SmsCountryApi::Group::Member.new
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::Member, obj, "Object isn't the correct type."
        assert_nil obj.id, "ID isn't nil."
        assert_nil obj.name, "Name isn't nil."
        assert_nil obj.number, "Number isn't nil."

    end

    def test_member_to_hash

        hash     = { 'Id'     => 15,
                     'Name'   => 'Joe Average',
                     'Number' => PHONE_NUMBER }
        obj      = SmsCountryApi::Group::Member.create(PHONE_NUMBER, id: 15, name: 'Joe Average')
        new_hash = obj.to_hash
        refute_nil new_hash, "New hash not created."
        new_hash.each do |k, v|
            assert_equal hash[k], v, "#{k} item did not match."
        end

    end

    def test_member_create

        # Required arguments only

        obj = SmsCountryApi::Group::Member.create(PHONE_NUMBER)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::Member, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBER, obj.number, "Number doesn't match."
        assert_nil obj.name, "Name isn't nil."
        assert_nil obj.id, "ID isn't nil."

        # Optional arguments

        obj = SmsCountryApi::Group::Member.create(PHONE_NUMBER, id: 15)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::Member, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBER, obj.number, "Number doesn't match."
        assert_nil obj.name, "Name isn't nil."
        assert_equal 15, obj.id, "ID doesn't match."

        obj = SmsCountryApi::Group::Member.create(PHONE_NUMBER, name: 'Joe Average')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::Member, obj, "Object isn't the correct type."
        assert_equal PHONE_NUMBER, obj.number, "Number doesn't match."
        assert_equal 'Joe Average', obj.name, "Name doesn't match."
        assert_nil obj.id, "ID isn't nil."

    end

    def test_member_create_bad_args

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.create(nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.create('')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.create(15)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.create(PHONE_NUMBER, id: '')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.create(PHONE_NUMBER, id: 15.0)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.create(PHONE_NUMBER, name: '')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.create(PHONE_NUMBER, name: 15)
        end

    end

    def test_member_from_hash

        hash = { 'Id'     => 15,
                 'Name'   => 'Joe Average',
                 'Number' => PHONE_NUMBER }
        obj  = SmsCountryApi::Group::Member.from_hash(hash)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::Member, obj, "Object isn't the correct type."
        assert_equal hash['Number'], obj.number, "Number doesn't match."
        assert_equal hash['Name'], obj.name, "Name doesn't match."
        assert_equal hash['Id'], obj.id, "ID doesn't match."

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.from_hash(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::Member.from_hash('')
        end

    end

    # endregion Member class

    # region GroupDetail class

    def test_groupdetail_constructor_and_accessors

        obj = SmsCountryApi::Group::GroupDetail.new
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::GroupDetail, obj, "Object isn't the correct type."
        assert_nil obj.id, "ID isn't nil."
        assert_nil obj.name, "Name isn't nil."
        assert_nil obj.tiny_name, "Tiny name isn't nil."
        assert_nil obj.start_call_on_enter, "Start call on enter isn't nil."
        assert_nil obj.end_call_on_exit, "End call on exit isn't nil."
        assert_nil obj.members, "Members isn't nil."

    end

    def test_groupdetail_to_hash

        hash     = { 'Id'                    => 15,
                     'Name'                  => 'Group 1',
                     'TinyName'              => 'g1',
                     'StartGroupCallOnEnter' => '18885554444',
                     'EndGroupCallOnExit'    => '18884445555',
                     'Members'               => [
                         { 'Number' => PHONE_NUMBER, 'Id' => 15, 'Name' => 'Joe Average' },
                         { 'Number' => '18882229999', 'Id' => 17, 'Name' => 'John Doe' }
                     ] }
        m1       = SmsCountryApi::Group::Member.create(PHONE_NUMBER, id: 15, name: 'Joe Average')
        m2       = SmsCountryApi::Group::Member.create('18882229999', id: 17, name: 'John Doe')
        obj      = SmsCountryApi::Group::GroupDetail.create('Group 1',
                                                            tiny_name:           'g1',
                                                            start_call_on_enter: '18885554444',
                                                            end_call_on_exit:    '18884445555',
                                                            members:             [m1, m2])
        new_hash = obj.to_hash
        refute_nil new_hash, "New hash not created."
        new_hash.each do |k, v|
            if k == 'Members'
                assert_equal hash[k].length, v.length, "#{k} lengths do not match."
                (0..v.length-1).each do |i|
                    exp_hash = hash[k][i]
                    act_hash = v[i]
                    act_hash.each do |km, vm|
                        assert_equal exp_hash[km], vm, "#{k} #{i} #{km} item did not match."
                    end
                end
            else
                assert_equal hash[k], v, "#{k} item did not match."
            end
        end

    end

    def test_groupdetail_create

        # Required arguments only

        m1 = SmsCountryApi::Group::Member.create(PHONE_NUMBER, id: 15, name: 'Joe Average')
        m2 = SmsCountryApi::Group::Member.create('18882229999', id: 17, name: 'John Doe')

        obj = SmsCountryApi::Group::GroupDetail.create('Group 1')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::GroupDetail, obj, "Object isn't the correct type."
        assert_equal 'Group 1', obj.name, "Name doesn't match."
        assert_nil obj.id, "ID isn't nil."
        assert_nil obj.tiny_name, "Tiny name isn't nil."
        assert_nil obj.start_call_on_enter, "Start call on enter isn't nil."
        assert_nil obj.end_call_on_exit, "End call on exit isn't nil."
        assert_nil obj.members, "Members isn't nil."

        # Optional arguments
        obj = SmsCountryApi::Group::GroupDetail.create('Group 1', id: 15)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::GroupDetail, obj, "Object isn't the correct type."
        assert_equal 'Group 1', obj.name, "Name doesn't match."
        assert_equal 15, obj.id, "ID doesn't match."
        assert_nil obj.tiny_name, "Tiny name isn't nil."
        assert_nil obj.start_call_on_enter, "Start call on enter isn't nil."
        assert_nil obj.end_call_on_exit, "End call on exit isn't nil."
        assert_nil obj.members, "Members isn't nil."

        obj = SmsCountryApi::Group::GroupDetail.create('Group 1', tiny_name: 'g1')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::GroupDetail, obj, "Object isn't the correct type."
        assert_equal 'Group 1', obj.name, "Name doesn't match."
        assert_nil obj.id, "ID isn't nil."
        assert_equal 'g1', obj.tiny_name, "Tiny name doesn't match."
        assert_nil obj.start_call_on_enter, "Start call on enter isn't nil."
        assert_nil obj.end_call_on_exit, "End call on exit isn't nil."
        assert_nil obj.members, "Members isn't nil."

        obj = SmsCountryApi::Group::GroupDetail.create('Group 1', start_call_on_enter: 'yes')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::GroupDetail, obj, "Object isn't the correct type."
        assert_equal 'Group 1', obj.name, "Name doesn't match."
        assert_nil obj.id, "ID isn't nil."
        assert_nil obj.tiny_name, "Tiny name isn't nil."
        assert_equal 'yes', obj.start_call_on_enter, "Start call on enter doesn't match."
        assert_nil obj.end_call_on_exit, "End call on exit isn't nil."
        assert_nil obj.members, "Members isn't nil."

        obj = SmsCountryApi::Group::GroupDetail.create('Group 1', end_call_on_exit: 'yes')
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::GroupDetail, obj, "Object isn't the correct type."
        assert_equal 'Group 1', obj.name, "Name doesn't match."
        assert_nil obj.id, "ID isn't nil."
        assert_nil obj.tiny_name, "Tiny name isn't nil."
        assert_nil obj.start_call_on_enter, "Start call on enter isn't nil."
        assert_equal 'yes', obj.end_call_on_exit, "End call on exit doesn't match."
        assert_nil obj.members, "Members isn't nil."

        obj = SmsCountryApi::Group::GroupDetail.create('Group 1', members: [m1, m2])
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::GroupDetail, obj, "Object isn't the correct type."
        assert_equal 'Group 1', obj.name, "Name doesn't match."
        assert_nil obj.id, "ID isn't nil."
        assert_nil obj.tiny_name, "Tiny name isn't nil."
        assert_nil obj.start_call_on_enter, "Start call on enter isn't nil."
        assert_nil obj.end_call_on_exit, "End call on exit isn't nil."
        refute_nil obj.members, "Members is nil."
        assert_equal 2, obj.members.length, "Members length isn't correct."
        assert_equal m1.id, obj.members[0].id, "Member 1 ID doesn't match."
        assert_equal m1.name, obj.members[0].name, "Member 1 name doesn't match."
        assert_equal m1.number, obj.members[0].number, "Member 1 number doesn't match."
        assert_equal m2.id, obj.members[1].id, "Member 2 ID doesn't match."
        assert_equal m2.name, obj.members[1].name, "Member 2 name doesn't match."
        assert_equal m2.number, obj.members[1].number, "Member 2 number doesn't match."

    end

    def test_groupdetail_create_bad_args

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.create(nil)
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.create('')
        end
        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.create(15)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.create('Group 1', id: 'x')
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.create('Group 1', tiny_name: 15)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.create('Group 1', start_call_on_enter: 15)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.create('Group 1', end_call_on_exit: 15)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.create('Group 1', members: 15)
        end

    end

    def test_groupdetail_from_hash

        hash = { 'Id'                    => 15,
                 'Name'                  => 'Group 1',
                 'TinyName'              => 'g1',
                 'StartGroupCallOnEnter' => '18885554444',
                 'EndGroupCallOnExit'    => '18884445555',
                 'Members'               => [
                     { 'Number' => PHONE_NUMBER, 'Id' => 15, 'Name' => 'Joe Average' },
                     { 'Number' => '18882229999', 'Id' => 17, 'Name' => 'John Doe' }
                 ] }
        obj  = SmsCountryApi::Group::GroupDetail.from_hash(hash)
        refute_nil obj, "Object wasn't created successfully."
        assert_kind_of SmsCountryApi::Group::GroupDetail, obj, "Object isn't the correct type."
        assert_equal hash['Id'], obj.id, "ID doesn't match."
        assert_equal hash['Name'], obj.name, "Name doesn't match."
        assert_equal hash['TinyName'], obj.tiny_name, "Tiny name doesn't match."
        assert_equal hash['StartGroupCallOnEnter'], obj.start_call_on_enter, "Start call on enter doesn't match."
        assert_equal hash['EndGroupCallOnExit'], obj.end_call_on_exit, "End call on exit doesn't match."
        assert_equal hash['Members'].length, obj.members.length, "Members length doesn't match."
        (0..obj.members.length-1).each do |i|
            assert_equal hash['Members'][i]['Number'], obj.members[i].number, "Members #{i} number doesn't match."
            assert_equal hash['Members'][i]['Id'], obj.members[i].id, "Members #{i} id doesn't match."
            assert_equal hash['Members'][i]['Name'], obj.members[i].name, "Members #{i} name doesn't match."
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.from_hash(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group::GroupDetail.from_hash('')
        end

    end

    # endregion GroupDetail class

    # region Group class

    def test_constructor

        endpoint = SmsCountryApi::Endpoint.new("abcdefghijkl", "xyzzy")
        refute_nil endpoint, "Endpoint was not successfully created."
        obj = SmsCountryApi::Group.new(endpoint)
        refute_nil obj, "Group object was not successfully created."
        assert_kind_of SmsCountryApi::Group, obj, "Group object isn't the right type."

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group.new(nil)
        end

        assert_raises ArgumentError do
            obj = SmsCountryApi::Group.new("Non-endpoint")
        end

    end

    # region #create_group method

    def test_create_group_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, MOCK_URI)
            .to_return(status: 201, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Group'   => {
                                                'Id'                    => 1,
                                                'Name'                  => 'group 1',
                                                'TinyName'              => 'sample short name',
                                                'StartGroupCallOnEnter' => '91XXXXXXXXXX',
                                                'EndGroupCallOnExit'    => '91XXXXXXXXXX',
                                                'Members'               => [
                                                    {
                                                        'Id'     => 1567,
                                                        'Name'   => 'someone',
                                                        'Number' => '91XXXXXXXXXX'
                                                    },
                                                    {
                                                        'Id'     => 1568,
                                                        'Name'   => 'xyzzy',
                                                        'Mobile' => '971XXXXXXXX'
                                                    }
                                                ]
                                            } }.to_json)
        m1                   = SmsCountryApi::Group::Member.create('91XXXXXXXXXX', id: 1567, name: 'someone')
        m2                   = SmsCountryApi::Group::Member.create('91XXXXXXXXXX', id: 1568, name: 'xyzzy')
        status, group_detail = client.group.create_group('group 1',
                                                         tiny_name:           'sample short name',
                                                         start_call_on_enter: '91XXXXXXXXXX',
                                                         end_call_on_exit:    '91XXXXXXXXXX',
                                                         members:             [m1, m2])
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil group_detail, "No group detail object returned."
        assert_kind_of SmsCountryApi::Group::GroupDetail, group_detail, "Returned group detail object isn't the right type."
        assert_equal 1, group_detail.id, "ID isn't correct."
        assert_equal 'group 1', group_detail.name, "Name isn't correct."
        assert_equal 'sample short name', group_detail.tiny_name, "Tiny name isn't correct."
        assert_equal '91XXXXXXXXXX', group_detail.start_call_on_enter, "Start call on enter isn't correct."
        assert_equal '91XXXXXXXXXX', group_detail.end_call_on_exit, "End call on exit isn't correct."
        refute_nil group_detail.members, "Members is nil."
        assert_equal 2, group_detail.members.length, "Members length isn't correct."

    end

    def test_create_group_bad_name

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, MOCK_URI)
            .to_return(status: 201, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, group_detail = client.group.create_group(nil)
        end

        assert_raises ArgumentError do
            status, group_detail = client.group.create_group('')
        end

        assert_raises ArgumentError do
            status, group_detail = client.group.create_group(754)
        end

    end

    def test_create_group_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, MOCK_URI)
            .to_raise(StandardError)
        status, group_detail = client.group.create_group('Group 1')
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil group_detail, "Returned group detail object was not nil."

    end

    # endregion #create_group method

    # region #get_group_details method

    def test_get_group_details_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Group'   => {
                                                'Id'                    => 1,
                                                'Name'                  => 'group 1',
                                                'TinyName'              => 'sample short name',
                                                'StartGroupCallOnEnter' => '91XXXXXXXXXX',
                                                'EndGroupCallOnExit'    => '91XXXXXXXXXX',
                                                'Members'               => [
                                                    {
                                                        'Id'     => 1567,
                                                        'Name'   => 'someone',
                                                        'Number' => '91XXXXXXXXXX'
                                                    },
                                                    {
                                                        'Id'     => 1568,
                                                        'Name'   => 'xyzzy',
                                                        'Mobile' => '971XXXXXXXX'
                                                    }
                                                ]
                                            } }.to_json)
        status, group_detail = client.group.get_group_details(1)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil group_detail, "No group detail object returned."
        assert_kind_of SmsCountryApi::Group::GroupDetail, group_detail, "Returned group detail object isn't the right type."
        assert_equal 1, group_detail.id, "ID isn't correct."
        assert_equal 'group 1', group_detail.name, "Name isn't correct."
        assert_equal 'sample short name', group_detail.tiny_name, "Tiny name isn't correct."
        assert_equal '91XXXXXXXXXX', group_detail.start_call_on_enter, "Start call on enter isn't correct."
        assert_equal '91XXXXXXXXXX', group_detail.end_call_on_exit, "End call on exit isn't correct."
        refute_nil group_detail.members, "Members is nil."
        assert_equal 2, group_detail.members.length, "Members length isn't correct."

    end

    def test_get_group_details_bad_id

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, group_detail = client.group.get_group_details(nil)
        end

        assert_raises ArgumentError do
            status, group_detail = client.group.get_group_details('')
        end

    end

    def test_get_group_details_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_raise(StandardError)
        status, group_detail = client.group.get_group_details(57)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil group_detail, "Returned group detail object was not nil."

    end

    # endregion #get_group_details method

    # region #get_group_collection method

    def test_get_group_collection_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        g1         = {
            'Id'                    => 1,
            'Name'                  => 'group 1',
            'TinyName'              => 'sample short name',
            'StartGroupCallOnEnter' => '91XXXXXXXXXX',
            'EndGroupCallOnExit'    => '91XXXXXXXXXX',
            'Members'               => [
                {
                    'Id'     => 1567,
                    'Name'   => 'someone',
                    'Number' => '91XXXXXXXXXX'
                },
                {
                    'Id'     => 1568,
                    'Name'   => 'xyzzy',
                    'Mobile' => '971XXXXXXXX'
                }
            ] }
        g2         = {
            'Id'                    => 2,
            'Name'                  => 'group 2',
            'TinyName'              => 'sample short name',
            'StartGroupCallOnEnter' => '91XXXXXXXXXX',
            'EndGroupCallOnExit'    => '91XXXXXXXXXX',
            'Members'               => [
                {
                    'Id'     => 1561,
                    'Name'   => 'someone',
                    'Number' => '91XXXXXXXXXX'
                },
                {
                    'Id'     => 1562,
                    'Name'   => 'xyzzy',
                    'Mobile' => '971XXXXXXXX'
                }
            ] }
        group_list = [g1, g2]
        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Groups'  => group_list }.to_json)

        status, details_list = client.group.get_group_collection
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of group detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 2, details_list.length, "Details list is the wrong length."
        assert_equal "group 1", details_list[0].name, "First group name isn't correct."
        assert_equal "group 2", details_list[1].name, "Second group name isn't correct."

    end

    def test_get_group_collection_filters

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        g1 = {
            'Id'                    => 1,
            'Name'                  => 'group 1 able',
            'TinyName'              => 'g1',
            'StartGroupCallOnEnter' => '91XXXXXXXXXY',
            'EndGroupCallOnExit'    => '91XXXXXXXXXY',
            'Members'               => [
                {
                    'Id'     => 1567,
                    'Name'   => 'someone',
                    'Number' => '91XXXXXXXXXX'
                },
                {
                    'Id'     => 1568,
                    'Name'   => 'xyzzy',
                    'Mobile' => '971XXXXXXXX'
                }
            ] }
        g2 = {
            'Id'                    => 2,
            'Name'                  => 'group 2 baker',
            'TinyName'              => 'g2',
            'StartGroupCallOnEnter' => '91XXXXXXXXXZ',
            'EndGroupCallOnExit'    => '91XXXXXXXXXZ',
            'Members'               => [
                {
                    'Id'     => 1561,
                    'Name'   => 'someone',
                    'Number' => '91XXXXXXXXXX'
                },
                {
                    'Id'     => 1562,
                    'Name'   => 'xyzzy',
                    'Mobile' => '971XXXXXXXX'
                }
            ] }

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)
        stub_request(:get, MOCK_URI).with(query: { 'nameLike' => 'baker' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Groups'  => [g2] }.to_json)
        status, details_list = client.group.get_group_collection(name_like: 'baker')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of group detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 1, details_list.length, "Details list is the wrong length."
        assert_equal "group 2 baker", details_list[0].name, "Returned group name isn't correct."

        WebMock.reset!

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)
        stub_request(:get, MOCK_URI).with(query: { 'tinyName' => 'g1' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Groups'  => [g1] }.to_json)
        status, details_list = client.group.get_group_collection(tiny_name: 'g1')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of group detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 1, details_list.length, "Details list is the wrong length."
        assert_equal "group 1 able", details_list[0].name, "Returned group name isn't correct."

        WebMock.reset!

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)
        stub_request(:get, MOCK_URI).with(query: { 'startGroupCallOnEnter' => '91XXXXXXXXXZ' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Groups'  => [g2] }.to_json)
        status, details_list = client.group.get_group_collection(start_call_on_enter: '91XXXXXXXXXZ')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of group detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 1, details_list.length, "Details list is the wrong length."
        assert_equal "group 2 baker", details_list[0].name, "Returned group name isn't correct."

        WebMock.reset!

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)
        stub_request(:get, MOCK_URI).with(query: { 'endGroupCallOnExit' => '91XXXXXXXXXY' })
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Groups'  => [g1] }.to_json)
        status, details_list = client.group.get_group_collection(end_call_on_exit: '91XXXXXXXXXY')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message
        refute_nil details_list, "No list of group detail objects returned."
        assert_kind_of Array, details_list, "Details list isn't an array."
        assert_equal 1, details_list.length, "Details list is the wrong length."
        assert_equal "group 1 able", details_list[0].name, "Returned group name isn't correct."

    end

    def test_get_group_collection_no_groups

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Groups'  => nil }.to_json)

        status, details_list = client.group.get_group_collection
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "No list of group details included in response.", status.message, "Unexpected message in status."
        assert_nil details_list, "Detail list was not nil."

    end

    def test_get_group_collection_bad_arguments

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, detail_list = client.group.get_group_collection(name_like: 754)
        end

        assert_raises ArgumentError do
            status, detail_list = client.group.get_group_collection(tiny_name: 754)
        end

        assert_raises ArgumentError do
            status, detail_list = client.group.get_group_collection(start_call_on_enter: 574)
        end

        assert_raises ArgumentError do
            status, detail_list = client.group.get_group_collection(end_call_on_exit: 574)
        end

        assert_raises ArgumentError do
            status, detail_list = client.group.get_group_collection(offset: '')
        end

        assert_raises ArgumentError do
            status, detail_list = client.group.get_group_collection(limit: '')
        end

    end

    def test_get_group_collection_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_raise(StandardError)
        status, group_collection = client.group.get_group_collection
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."
        assert_nil group_collection, "Returned group collection was not nil."

    end

    # endregion #get_group_collection method

    # region #update_group method

    def test_update_group_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, MOCK_URI)
            .to_return(status: 202, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)
        status, = client.group.update_group(17, 'bogus')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message

    end

    def test_update_group_optional_arguments

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, MOCK_URI)
            .to_return(status: 202, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, = client.group.update_group(17, 'bogus', tiny_name: 'bg')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message

        status, = client.group.update_group(17, 'bogus', start_call_on_enter: '91x')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message

        status, = client.group.update_group(17, 'bogus', end_call_on_exit: '91x')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message

    end

    def test_update_group_bad_arguments

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, MOCK_URI)
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, = client.group.update_group(nil, 'bogus')
        end
        assert_raises ArgumentError do
            status, = client.group.update_group('', 'bogus')
        end

        assert_raises ArgumentError do
            status, = client.group.update_group(17, '')
        end
        assert_raises ArgumentError do
            status, = client.group.update_group(17, nil)
        end
        assert_raises ArgumentError do
            status, = client.group.update_group(17, 754)
        end

        assert_raises ArgumentError do
            status, = client.group.update_group(17, 'bogus', tiny_name: 754)
        end

        assert_raises ArgumentError do
            status, = client.group.update_group(17, 'bogus', start_call_on_enter: 754)
        end

        assert_raises ArgumentError do
            status, = client.group.update_group(17, 'bogus', end_call_on_exit: 754)
        end

    end

    def test_update_group_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, MOCK_URI)
            .to_raise(StandardError)
        status, = client.group.update_group(17, 'bogus')
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #update_group method

    # region #delete_group method

    def test_delete_group_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, MOCK_URI)
            .to_return(status: 204)

        status, = client.group.delete_group(17)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s

    end

    def test_delete_group_bad_argument

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, MOCK_URI)
            .to_return(status: 400)

        assert_raises ArgumentError do
            status, = client.group.delete_group(nil)
        end

        assert_raises ArgumentError do
            status, = client.group.delete_group('')
        end

    end

    def test_delete_group_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, MOCK_URI)
            .to_raise(StandardError)
        status, = client.group.delete_group(17)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #delete_group method

    # region #add_member_to_group method

    def test_add_member_to_group_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, MOCK_URI)
            .to_return(status: 201, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Member'  => { 'Id'     => 15,
                                                           'Name'   => 'someone',
                                                           'Number' => '91XXXXXXXXXX' } }.to_json)

        status, member = client.group.add_member_to_group(17, '91XXXXXXXXXX', name: 'someone')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s
        assert_equal 15, member.id, "ID is not correct."
        assert_equal 'someone', member.name, "Name is not correct."
        assert_equal '91XXXXXXXXXX', member.number, "Number is not correct."

    end

    def test_add_member_to_group_bad_arguments

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, MOCK_URI)
            .to_return(status: 201, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, member = client.group.add_member_to_group(nil, '91XXXXXXXXXX')
        end
        assert_raises ArgumentError do
            status, member = client.group.add_member_to_group('', '91XXXXXXXXXX')
        end

        assert_raises ArgumentError do
            status, member = client.group.add_member_to_group(17, '')
        end
        assert_raises ArgumentError do
            status, member = client.group.add_member_to_group(17, nil)
        end
        assert_raises ArgumentError do
            status, member = client.group.add_member_to_group(17, 754)
        end

        assert_raises ArgumentError do
            status, member = client.group.add_member_to_group(17, '91XXXXXXXXXX', name: 754)
        end

    end

    def test_add_member_to_group_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:post, MOCK_URI)
            .to_raise(StandardError)
        status, member = client.group.add_member_to_group(17, '91XXXXXXXXXX', name: 'someone')
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #add_member_to_group method

    # region #get_members_of_group method

    def test_get_members_of_group_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Members' => [{ 'Id'     => 15,
                                                            'Name'   => 'someone',
                                                            'Number' => '91XXXXXXXXXX' },
                                                          { 'Id'     => 29,
                                                            'Name'   => 'anybody',
                                                            'Number' => '91XXXXXXYYYY' }] }.to_json)

        status, member_list = client.group.get_members_of_group(17)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s
        refute_nil member_list, "No member list returned."
        assert_equal 2, member_list.length, "Member list length is not correct."
        assert_equal 15, member_list[0].id, "Member 1 ID is not correct."
        assert_equal 'someone', member_list[0].name, "Member 1 name is not correct."
        assert_equal '91XXXXXXXXXX', member_list[0].number, "Member 1 number is not correct."
        assert_equal 29, member_list[1].id, "Member 2 ID is not correct."
        assert_equal 'anybody', member_list[1].name, "Member 2 name is not correct."
        assert_equal '91XXXXXXYYYY', member_list[1].number, "Member 2 number is not correct."

    end

    def test_get_members_of_group_bad_argument

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, member_list = client.group.get_members_of_group(nil)
        end

        assert_raises ArgumentError do
            status, member_list = client.group.get_members_of_group('')
        end

    end

    def test_get_members_of_group_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_raise(StandardError)
        status, member_list = client.group.get_members_of_group(17)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #get_members_of_group method

    # region #get_member method

    def test_get_member_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID,
                                            'Member'  => { 'Id'     => 15,
                                                           'Name'   => 'someone',
                                                           'Number' => '91XXXXXXXXXX' } }.to_json)

        status, member = client.group.get_member(17, 15)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s
        refute_nil member, "No member item returned."
        assert_equal 15, member.id, "ID is not correct."
        assert_equal 'someone', member.name, "Name is not correct."
        assert_equal '91XXXXXXXXXX', member.number, "Number is not correct."

    end

    def test_get_member_bad_argument

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_return(status: 200, body: { 'Success' => false,
                                            'Message' => "Operation failed",
                                            'ApiId'   => API_ID }.to_json)

        assert_raises ArgumentError do
            status, member_list = client.group.get_member(nil, 15)
        end
        assert_raises ArgumentError do
            status, member_list = client.group.get_member('', 15)
        end

        assert_raises ArgumentError do
            status, member_list = client.group.get_member(17, nil)
        end
        assert_raises ArgumentError do
            status, member_list = client.group.get_member(17, '')
        end

    end

    def test_get_member_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:get, MOCK_URI)
            .to_raise(StandardError)
        status, member = client.group.get_member(17, 15)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #get_member method

    # region #update_member method

    def test_update_member_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, MOCK_URI)
            .to_return(status: 202, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, = client.group.update_member(17, 5, '91XXXXXXXXXX')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s

    end

    def test_update_member_optional_argument

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, MOCK_URI)
            .to_return(status: 202, body: { 'Success' => true,
                                            'Message' => "Operation succeeded",
                                            'ApiId'   => API_ID }.to_json)

        status, = client.group.update_member(17, 5, '91XXXXXXXXXX', name: 'nobody')
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s

    end

    def test_update_member_bad_arguments

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, MOCK_URI)
            .to_return(status: 202, body: { 'Success' => false,
                                            'Message' => "Operation failed" }.to_json)

        assert_raises ArgumentError do
            status, = client.group.update_member(nil, 7, '91XXXXXXXXXX')
        end
        assert_raises ArgumentError do
            status, = client.group.update_member('', 7, '91XXXXXXXXXX')
        end

        assert_raises ArgumentError do
            status, = client.group.update_member(15, nil, '91XXXXXXXXXX')
        end
        assert_raises ArgumentError do
            status, = client.group.update_member(15, '', '91XXXXXXXXXX')
        end

        assert_raises ArgumentError do
            status, = client.group.update_member(15, 7, nil)
        end
        assert_raises ArgumentError do
            status, = client.group.update_member(15, 7, '')
        end
        assert_raises ArgumentError do
            status, = client.group.update_member(15, 7, 754)
        end

        assert_raises ArgumentError do
            status, = client.group.update_member(15, 7, '91XXXXXXXXXX', name: 754)
        end

    end

    def test_update_member_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:patch, MOCK_URI)
            .to_raise(StandardError)

        status, = client.group.update_member(17, 5, '91XXXXXXXXXX', name: 'nobody')
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #update_member method

    # region #delete_member_from_group method

    def test_delete_member_from_group_basic_success

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, MOCK_URI)
            .to_return(status: 204)

        status, = client.group.delete_member_from_group(17, 5)
        refute_nil status, "No status object returned."
        assert status.success, "Status did not indicate success: " + status.message.to_s

    end

    def test_delete_member_from_group_bad_arguments

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, MOCK_URI)
            .to_return(status: 400)

        assert_raises ArgumentError do
            status, = client.group.delete_member_from_group(nil, 7)
        end

        assert_raises ArgumentError do
            status, = client.group.delete_member_from_group('', 7)
        end

        assert_raises ArgumentError do
            status, = client.group.delete_member_from_group(7, nil)
        end

        assert_raises ArgumentError do
            status, = client.group.delete_member_from_group(7, '')
        end

    end

    def test_delete_member_from_group_exception_from_restclient

        client = create_mock_client
        refute_nil client, "Client object couldn't be created."

        stub_request(:delete, MOCK_URI)
            .to_raise(StandardError)
        status, = client.group.delete_member_from_group(17, 5)
        refute_nil status, "No status object returned."
        refute status.success, "Status did not indicate failure: " + status.message
        assert_equal "Exception from WebMock", status.message, "Unexpected error message encountered."

    end

    # endregion #delete_member_from_group method

    # endregion Group class

end
