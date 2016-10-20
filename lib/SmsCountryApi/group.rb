#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require 'rest-client'
require 'addressable'

module SmsCountryApi

    # Access to the `Groups` interface to manage groups of people.
    class Group

        # Path component for groups.
        GROUP_PATH  = "Groups"

        # Path component for group members.
        MEMBER_PATH = "Members"

        # region Member class

        # Member of a group.
        class Member

            #@!attribute [rw] id
            #   @return [Integer] Numeric ID of this group member.
            attr_accessor :id

            # @!attribute [rw] name
            #   @return [String] Name of group member.
            attr_accessor :name

            # @!attribute [rw] number
            #   @return [String] Number of group member.
            attr_accessor :number

            # Construct a blank member object
            #
            def initialize
                @id     = nil
                @name   = nil
                @number = nil
            end

            # Returns a hash representing the object.
            #
            # @return [Hash] Resulting hash.
            #
            def to_hash
                hash           = {}
                hash['Id']     = @id unless @id.nil?
                hash['Name']   = @name unless @name.nil?
                hash['Number'] = @number unless @number.nil?
                hash
            end

            # Construct a member object from a name and number.
            #
            # @param [String] number (required) Number of group member.
            # @param [String] name Name of group member.
            # @param [Integer] id Numeric ID of group member.
            #
            # @return [{Member}] New member object.
            #
            # @raise [ArgumentError] A required argument is missing or an argument is invalid.
            #
            def self.create(number, name: nil, id: nil)
                if number.nil? || !number.kind_of?(String) || number.empty?
                    raise ArgumentError, "Number must be a non-empty string."
                end
                if (!name.nil? && (!name.kind_of?(String) || name.empty?)) ||
                    (!id.nil? && !id.kind_of?(Integer))
                    raise ArgumentError, "Invalid argument type."
                end

                obj        = Member.new
                obj.number = number
                obj.name   = name
                obj.id     = id
                obj
            end

            # Construct a member object from a hash returned by the API.
            #
            # @param [Hash] hash Hash from the response.
            #
            # @return [{Member}] New member object.
            #
            def self.from_hash(hash)
                if hash.nil? || !hash.kind_of?(Hash)
                    raise ArgumentError, "Argument must be a hash."
                end
                obj = Member.new
                unless hash.nil?
                    hash.each do |k, v|
                        case k
                        when 'Number' then
                            obj.number = CGI.unescape(v) unless v.nil?
                        when 'Name' then
                            obj.name = CGI.unescape(v) unless v.nil?
                        when 'Id' then
                            obj.id = v unless v.nil?
                        end
                    end
                end
                obj
            end

        end

        # endregion Member class

        # region GroupDetail class

        # Representation of a group.
        class GroupDetail

            #@!attribute [rw] id
            #   @return [Integer] Numeric ID of this group.
            attr_accessor :id

            # @!attribute [rw] name
            #   @return [String] Name of group member.
            attr_accessor :name

            # @!attribute [rw] tiny_name
            #   @return [String] Short name of the group for display purposes.
            attr_accessor :tiny_name

            # @!attribute [rw] start_call_on_enter
            #   @return [String] If specified, a group call will not be started until this number answers the call.
            attr_accessor :start_call_on_enter

            # @!attribute [rw] end_call_on_exit
            #   @return [String] If specified, a group call will terminate when this number is disconnected or hangs up.
            attr_accessor :end_call_on_exit

            # @!attribute [rw] members
            #   @return [Array<Member>] Array of members of the group. May be empty.
            attr_accessor :members

            # Construct a blank object.
            #
            def initialize
                @id                  = nil
                @name                = nil
                @tiny_name           = nil
                @start_call_on_enter = nil
                @end_call_on_exit    = nil
                @members             = nil
            end

            # Returns a hash representing the object.
            #
            # @return [Hash] Resulting hash.
            #
            def to_hash
                hash                          = {}
                hash['Id']                    = @id unless @id.nil?
                hash['Name']                  = @name unless @name.nil?
                hash['TinyName']              = @tiny_name unless @tiny_name.nil?
                hash['StartGroupCallOnEnter'] = @start_call_on_enter unless @start_call_on_enter.nil?
                hash['EndGroupCallOnExit']    = @end_call_on_exit unless @end_call_on_exit.nil?
                unless @members.nil?
                    l = []
                    @members.each do |member|
                        l.push(member.to_hash)
                    end
                    hash['Members'] = l unless l.empty?
                end
                hash
            end

            # Construct a GroupDetail object from detail information.
            #
            # @param [String] name (required) Name of group.
            # @param [String] tiny_name Short name of the group for display purposes.
            # @param [String] start_call_on_enter If specified, a group call will not be started until this
            #                                     this number answers the call.
            # @param [String] end_call_on_exit If specified, a group call will terminate when this number
            #                                  is disconnected or hangs up.
            # @param [Array<Member>] members List of members of the group.
            # @param [Integer] id Numeric ID of the group.
            #
            # @return [{GroupDetail}] New group detail object.
            #
            # @raise [ArgumentError] A required argument is missing or an argument is invalid.
            #
            def self.create(name, tiny_name: nil, start_call_on_enter: nil, end_call_on_exit: nil, members: nil, id: nil)
                if name.nil? || !name.kind_of?(String) || name.empty?
                    raise ArgumentError, "Name must be a non-empty string."
                end
                if (!tiny_name.nil? && !tiny_name.kind_of?(String)) ||
                    (!start_call_on_enter.nil? && !start_call_on_enter.kind_of?(String)) ||
                    (!end_call_on_exit.nil? && !end_call_on_exit.kind_of?(String)) ||
                    (!members.nil? && !members.kind_of?(Array)) ||
                    (!id.nil? && !id.kind_of?(Integer))
                    raise ArgumentError, "Invalid argument type."
                end

                obj                     = GroupDetail.new
                obj.name                = name
                obj.tiny_name           = tiny_name
                obj.start_call_on_enter = start_call_on_enter
                obj.end_call_on_exit    = end_call_on_exit
                obj.members             = members
                obj.id                  = id
                obj
            end

            # Construct a new group detail object from a hash returned by the API.
            #
            # @param [Hash] hash Hash from the response.
            #
            # @return [{GroupDetail}] New group detail object.
            #
            def self.from_hash(hash)
                if hash.nil? || !hash.kind_of?(Hash)
                    raise ArgumentError, "Argument must be a hash."
                end
                obj = GroupDetail.new
                hash.each do |k, v|
                    case k
                    when 'Name' then
                        obj.name = CGI.unescape(v) unless v.nil?
                    when 'TinyName' then
                        obj.tiny_name = CGI.unescape(v) unless v.nil?
                    when 'StartGroupCallOnEnter' then
                        obj.start_call_on_enter = CGI.unescape(v) unless v.nil?
                    when 'EndGroupCallOnExit' then
                        obj.end_call_on_exit = CGI.unescape(v) unless v.nil?
                    when 'Id' then
                        obj.id = v unless v.nil?
                    when 'Members' then
                        unless v.nil?
                            member_list = []
                            v.each do |m|
                                member_list.push(Member.from_hash(m))
                            end
                            unless member_list.empty?
                                obj.members = member_list
                            end
                        end
                    end
                end
                obj
            end

        end

        # endregion GroupDetail class

        # Construct a Group object to make calls using a specific endpoint.
        #
        # @param [Endpoint] endpoint (required) Endpoint object to use for service URL and authentication parameters.
        #
        # @raise [ArgumentError] Endpoint is not valid.
        #
        def initialize(endpoint)
            if endpoint.nil? || !endpoint.kind_of?(Endpoint)
                raise ArgumentError, "A valid endpoint must be supplied."
            end

            @endpoint = endpoint
        end

        # Create a new group.
        #
        # @param [String] name (required) Name of the group.
        # @param [String] tiny_name Short name of the group for display purposes.
        # @param [String] start_call_on_enter If specified, a group call will not be started until this
        #                                     this number answers the call.
        # @param [String] end_call_on_exit If specified, a group call will terminate when this number
        #                                  is disconnected or hangs up.
        # @param [Array<Member>] members List of initial members of the group.
        #
        # @return [Array({StatusResponse}, {GroupDetail})]
        #   - Status of the operation.
        #   - {GroupDetail} object describing the newly-created group.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def create_group(name, tiny_name: nil, start_call_on_enter: nil, end_call_on_exit: nil, members: nil)
            if name.nil? || !name.kind_of?(String) || name.empty?
                raise ArgumentError, "Name must be a non-empty string."
            end

            values                          = { 'Name' => name }
            values['TinyName']              = tiny_name unless tiny_name.nil?
            values['StartGroupCallOnEnter'] = start_call_on_enter unless start_call_on_enter.nil?
            values['EndGroupCallOnExit']    = end_call_on_exit unless end_call_on_exit.nil?
            unless members.nil?
                l = []
                members.each do |member|
                    l.push(member.to_hash)
                end
                values['Members'] = members unless members.empty?
            end

            url     = @endpoint.url + GROUP_PATH + '/'
            headers = @endpoint.headers

            group_detail = nil
            begin
                response = RestClient.post url, values.to_json, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['Group']
                    group_detail   = GroupDetail.from_hash(hash) unless hash.nil?
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, group_detail
        end

        # Get details on a specific group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group to retrieve the details of.
        #
        # @return [Array({StatusResponse}, {GroupDetail})]
        #   - Status of the operation.
        #   - {GroupDetail} object with the details of the group but no members included.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def get_group_details(group_id)
            if group_id.nil? || !group_id.kind_of?(Integer)
                raise ArgumentError, "Group ID must be an integer."
            end

            url     = @endpoint.url + GROUP_PATH + '/' + group_id.to_s + '/'
            headers = @endpoint.headers

            group_detail = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['Group']
                    group_detail   = GroupDetail.from_hash(hash) unless hash.nil?
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, group_detail
        end

        # Retrieve details on all groups matching the criteria given.
        #
        # @param [String] name_like Find all groups whose names are like the given name.
        # @param [String] tiny_name Find all groups with this short name.
        # @param [String] start_call_on_enter Find all groups with this `start_call_on_enter` number.
        # @param [String] end_call_on_exit Find all groups with this `end_call_on_edit` number.
        #
        # @return [Array({StatusResponse}, Array<{GroupDetail}>, Integer, Integer)]
        #   - Status of the operation.
        #   - Array of {GroupDetail} objects with the details of the groups.
        #   - Offset value for next group of details if there are more matched than were returned,
        #     nil if not present in the response.
        #   - Limit value for the next group of details if there are more matched than were returned,
        #     nil if not present in the response.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_group_collection(name_like: nil, tiny_name: nil, start_call_on_enter: nil, end_call_on_exit: nil)
            if (!name_like.nil? && !name_like.kind_of?(String)) ||
                (!tiny_name.nil? && !tiny_name.kind_of?(String)) ||
                (!start_call_on_enter.nil? && !start_call_on_enter.kind_of?(String)) ||
                (!end_call_on_exit.nil? && !end_call_on_exit.kind_of?(String))
                raise ArgumentError, "Invalid argument type."
            end

            url          = @endpoint.url + GROUP_PATH + '/'
            query_string = ''
            query_string += '&nameLike=' + CGI.escape(name_like) unless name_like.nil?
            query_string += '&startGroupCallOnEnter=' + CGI.escape(start_call_on_enter) unless start_call_on_enter.nil?
            query_string += '&endGroupCallOnExit=' + CGI.escape(end_call_on_exit) unless end_call_on_exit.nil?
            query_string += '&tinyName=' + CGI.escape(tiny_name) unless tiny_name.nil?
            unless query_string.empty?
                query_string[0] = '?'
                url             += query_string
            end
            headers = @endpoint.headers

            next_offset = nil
            next_limit = nil
            returned_detail_list = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result     = StatusResponse.from_response(response)
                    group_details_list = result['Groups']
                    if !group_details_list.nil?
                        returned_detail_list = []
                        group_details_list.each do |details_hash|
                            details = GroupDetail.from_hash(details_hash)
                            returned_detail_list.push details
                        end
                    else
                        status = StatusResponse.new(false, "No list of group details included in response.")
                    end
                    next_string = result['Next']
                    unless next_string.nil? || next_string.empty?
                        a = Addressable::URI.parse(next_string)
                        h = a.query_values
                        s = h['Offset']
                        unless s.nil? || s.empty?
                            next_offset = s.to_i
                        end
                        s = h['Limit']
                        unless s.nil? || s.empty?
                            next_limit = s.to_i
                        end
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, returned_detail_list, next_offset, next_limit
        end

        # Update a specific group with the new details given. Details that are not given remain unchanged.
        #
        # @param [Integer] group_id (required) Numeric ID of the group to update.
        # @param [String] name (required) New name for the group.
        # @param [String] tiny_name New short name for the group.
        # @param [String] start_call_on_enter New `start_call_on_enter` number for the group.
        # @param [String] end_call_on_exit New `end_call_on_edit` number for the group.
        #
        # @return [Array({StatusResponse})]
        #   - Status of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def update_group(group_id, name, tiny_name: nil, start_call_on_enter: nil, end_call_on_exit: nil)
            if group_id.nil? || !group_id.kind_of?(Integer)
                raise ArgumentError, "Group ID must be an integer."
            end
            if name.nil? || !name.kind_of?(String) || name.empty?
                raise ArgumentError, "Name must be a non-empty string."
            end
            if (!tiny_name.nil? && !tiny_name.kind_of?(String)) ||
                (!start_call_on_enter.nil? && !start_call_on_enter.kind_of?(String)) ||
                (!end_call_on_exit.nil? && !end_call_on_exit.kind_of?(String))
                raise ArgumentError, "Invalid argument type."
            end

            url     = @endpoint.url + GROUP_PATH + '/' + group_id.to_s + '/'
            headers = @endpoint.headers

            values                          = { 'Name' => name }
            values['TinyName']              = tiny_name unless tiny_name.nil?
            values['StartGroupCallOnEnter'] = start_call_on_enter unless start_call_on_enter.nil?
            values['EndGroupCallOnExit']    = end_call_on_exit unless end_call_on_exit.nil?

            begin
                response = RestClient.patch url, values.to_json, headers
                if !response.nil?
                    status, _ = StatusResponse.from_response(response)
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            [status]
        end

        # Delete a specific group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group to delete.
        #
        # @return [Array({StatusResponse})]
        #   - Status of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def delete_group(group_id)
            if group_id.nil? || !group_id.kind_of?(Integer)
                raise ArgumentError, "Group ID must be an integer."
            end

            url     = @endpoint.url + GROUP_PATH + '/' + group_id.to_s + '/'
            headers = @endpoint.headers

            begin
                response = RestClient.delete url, headers
                if !response.nil?
                    status = StatusResponse.new((response.code / 100 == 2) ? true : false)
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            [status]
        end

        # Add a new member to an existing group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        # @param [String] number (required) Number of group member.
        # @param [String] name Name of group member.
        #
        # @return [Array({StatusResponse}, {Member})]
        #   - Status of the operation.
        #   - {Member} object of newly-created member.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def add_member_to_group(group_id, number, name: nil)
            if group_id.nil? || !group_id.kind_of?(Integer)
                raise ArgumentError, "Group ID must be an integer."
            end
            if number.nil? || !number.kind_of?(String) || number.empty?
                raise ArgumentError, "Number must be a non-empty string."
            end
            if !name.nil? && !name.kind_of?(String)
                raise ArgumentError, "Invalid argument type."
            end

            url     = @endpoint.url + GROUP_PATH + '/' + group_id.to_s + '/' + MEMBER_PATH + '/'
            headers = @endpoint.headers

            values         = { 'Number' => number }
            values['Name'] = name unless name.nil?

            member = nil
            begin
                response = RestClient.post url, values.to_json, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['Member']
                    member         = Member.from_hash(hash) unless hash.nil?
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, member
        end

        # Get all members of a specific group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        #
        # @return [Array({StatusResponse}, {Member})]
        #   - Status of the operation.
        #   - Array of {Member} objects in the group.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_members_of_group(group_id)
            if group_id.nil? || !group_id.kind_of?(Integer)
                raise ArgumentError, "Group ID must be an integer."
            end

            url     = @endpoint.url + GROUP_PATH + '/' + group_id.to_s + '/' + MEMBER_PATH + '/'
            headers = @endpoint.headers

            returned_member_list = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result      = StatusResponse.from_response(response)
                    member_details_list = result['Members']
                    if !member_details_list.nil?
                        returned_member_list = []
                        member_details_list.each do |details_hash|
                            details = Member.from_hash(details_hash)
                            returned_member_list.push details
                        end
                    else
                        status = StatusResponse.new(false, "No list of members included in response.")
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, returned_member_list
        end

        # Get details on a specific group member.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        # @param [Integer] member_id (required) Numeric ID of the member.
        #
        # @return [Array({StatusResponse}, {Member})]
        #   - Status of the operation.
        #   - {Member} object with details of requested member.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_member(group_id, member_id)
            if group_id.nil? || !group_id.kind_of?(Integer)
                raise ArgumentError, "Group ID must be an integer."
            end
            if member_id.nil? || !member_id.kind_of?(Integer)
                raise ArgumentError, "Member ID must be an integer."
            end

            url     = @endpoint.url + GROUP_PATH + '/' + group_id.to_s +
                '/' + MEMBER_PATH + '/' + member_id.to_s + '/'
            headers = @endpoint.headers

            member = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['Member']
                    member         = Member.from_hash(hash) unless hash.nil?
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, member

        end

        # Update the details of a specific group member.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        # @param [Integer] member_id (required) Numeric ID of the member.
        # @param [String] number (required) New number for group member.
        # @param [String] name New name of group member.
        #
        # @return [Array({StatusResponse})]
        #   - Status of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def update_member(group_id, member_id, number, name: nil)
            if group_id.nil? || !group_id.kind_of?(Integer)
                raise ArgumentError, "Group ID must be an integer."
            end
            if member_id.nil? || !member_id.kind_of?(Integer)
                raise ArgumentError, "Member ID must be an integer."
            end
            if number.nil? || !number.kind_of?(String) || number.empty?
                raise ArgumentError, "Number must be a non-empty string."
            end
            if !name.nil? && !name.kind_of?(String)
                raise ArgumentError, "Invalid argument type."
            end

            url     = @endpoint.url + GROUP_PATH + '/' + group_id.to_s +
                '/' + MEMBER_PATH + '/' + member_id.to_s + '/'
            headers = @endpoint.headers

            values         = { 'Number' => number }
            values['Name'] = name unless name.nil?

            begin
                response = RestClient.patch url, values.to_json, headers
                if !response.nil?
                    status, _ = StatusResponse.from_response(response)
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            [status]
        end

        # Delete a specific group member from the group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        # @param [Integer] member_id (required) Numeric ID of the member.
        #
        # @return [Array({StatusResponse})]
        #   - Status of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def delete_member_from_group(group_id, member_id)
            if group_id.nil? || !group_id.kind_of?(Integer)
                raise ArgumentError, "Group ID must be an integer."
            end
            if member_id.nil? || !member_id.kind_of?(Integer)
                raise ArgumentError, "Member ID must be an integer."
            end

            url     = @endpoint.url + GROUP_PATH + '/' + group_id.to_s +
                '/' + MEMBER_PATH + '/' + member_id.to_s + '/'
            headers = @endpoint.headers

            begin
                response = RestClient.delete url, headers
                if !response.nil?
                    status = StatusResponse.new((response.code / 100 == 2) ? true : false)
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            [status]
        end

    end

end
