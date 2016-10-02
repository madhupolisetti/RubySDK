#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require 'rest-client'

module SmsCountryApi

    # Access to the `Groups` interface to manage groups of people.
    class Group

        # Path component for groups.
        GROUP_PATH  = "Groups"

        # Path component for group members.
        MEMBER_PATH = "Members"

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

            # Construct a member object from a name and number.
            #
            # @param [String] number (required) Number of group member.
            # @param [String] name Name of group member.
            # @param [Integer] id Numeric ID of group member.
            #
            # @raise [ArgumentError] A required argument is missing or an argument is invalid.
            #
            def initialize(number, name: nil, id: 0)
                # TODO validate

                @number = number
                @name   = name
                @id     = id
            end
        end

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
            # @raise [ArgumentError] A required argument is missing or an argument is invalid.
            #
            def initialize(name, tiny_name: nil, start_call_on_enter: nil, end_call_on_exit: nil, members: nil, id: 0)
                # TODO validate

                @name                = name
                @tiny_name           = tiny_name
                @start_call_on_enter = start_call_on_enter
                @end_call_on_exit    = end_call_on_exit
                @members             = members || []
                @id                  = id
            end

        end

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
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::   API UUID as a string.
        # Success:: `true` or `false` indicating the success or failure of the operation.
        # Message:: Message describing the action result.
        # Group::   {GroupDetail} object describing the newly-created group.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def create_group(name, tiny_name: nil, start_call_on_enter: nil, end_call_on_exit: nil, members: nil)
            # TODO
        end

        # Get details on a specific group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group to retrieve the details of.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::   API UUID as a string.
        # Success:: `true` or `false` indicating the success or failure of the operation.
        # Message:: Message describing the action result.
        # Group::   {GroupDetail} object with the details of the group but no members included.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def get_group_details(group_id)
            # TODO
        end

        # Retrieve details on all groups matching the criteria given.
        #
        # @param [String] name_like Find all groups whose names are like the given name.
        # @param [String] tiny_name Find all groups with this short name.
        # @param [String] start_call_on_enter Find all groups with this `start_call_on_enter` number.
        # @param [String] end_call_on_exit Find all groups with this `end_call_on_edit` number.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::   API UUID as a string.
        # Success:: `true` or `false` indicating the success or failure of the operation.
        # Message:: Message describing the action result.
        # Groups::  Array of {GroupDetail} objects with the details of the matching groups.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_group_collection(name_like: nil, tiny_name: nil, start_call_on_enter: nil, end_call_on_exit: nil)
            # TODO
        end

        # Update a specific group with the new details given. Details that are not given remain unchanged.
        #
        # @param [Integer] group_id (required) Numeric ID of the group to update.
        # @param [String] name New name for the group.
        # @param [String] tiny_name New short name for the group.
        # @param [String] start_call_on_enter New `start_call_on_enter` number for the group.
        # @param [String] end_call_on_exit New `end_call_on_edit` number for the group.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::   API UUID as a string.
        # Success:: `true` or `false` indicating the success or failure of the operation.
        # Message:: Message describing the action result.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def update_group(group_id, name: nil, tiny_name: nil, start_call_on_enter: nil, end_call_on_exit: nil)
            # TODO
        end

        # Delete a specific group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group to delete.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # Success:: `true` or `false` indicating the success or failure of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def delete_group(group_id)
            # TODO
        end

        # Add a new member to an existing group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        # @param [String] number (required) Number of group member.
        # @param [String] name Name of group member.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::   API UUID as a string.
        # Success:: `true` or `false` indicating the success or failure of the operation.
        # Message:: Message describing the action result.
        # Member::  {Member} object describing the new group member.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def add_member_to_group(group_id, number, name: nil)
            # TODO
        end

        # Get all members of a specific group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::   API UUID as a string.
        # Success:: `true` or `false` indicating the success or failure of the operation.
        # Message:: Message describing the action result.
        # Members:: Array of {Member} objects describing the group's members.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_members_of_group(group_id)
            # TODO
        end

        # Get details on a specific group member.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        # @param [Integer] member_id (required) Numeric ID of the member.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::   API UUID as a string.
        # Success:: `true` or `false` indicating the success or failure of the operation.
        # Message:: Message describing the action result.
        # Member::  {Member} object describing the new group member.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_member(group_id, member_id)
            # TODO
        end

        # Update the details of a specific group member.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        # @param [Integer] member_id (required) Numeric ID of the member.
        # @param [String] name New name of group member.
        # @param [String] number New number for group member.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::   API UUID as a string.
        # Success:: `true` or `false` indicating the success or failure of the operation.
        # Message:: Message describing the action result.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def update_member(group_id, member_id, name: nil, number: nil)
            # TODO
        end

        # Delete a specific group member from the group.
        #
        # @param [Integer] group_id (required) Numeric ID of the group.
        # @param [Integer] member_id (required) Numeric ID of the member.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # Success:: `true` or `false` indicating the success or failure of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def delete_member_from_group(group_id, member_id)
            # TODO
        end

    end

end
