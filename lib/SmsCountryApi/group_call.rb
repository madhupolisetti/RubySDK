#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require 'rest-client'

module SmsCountryApi

    # Access to the `GroupCalls` interface. Used to initiate and manage calls to groups of people.
    class GroupCall

        # Path component for group calls
        GROUP_CALL_PATH   = "GroupCalls"

        # Path component for participants
        PARTICIPANTS_PATH = "Participants"

        # Path component for playing sounds.
        PLAY_PATH         = "Play"

        # Path component for muting calls.
        MUTE_PATH         = "Mute"

        # Path component for unmuting calls.
        UNMUTE_PATH       = "UnMute"

        # Path component for recordings.
        RECORDING_PATH    = "Recordings"

        # Path component for terminating a call.
        HANGUP_PATH       = "Hangup"

        # A single call for a participant.
        # @todo Finish implementing.
        class SingleCall

            # TODO

        end

        # A recording of a call.
        class Recording

            # @!attribute [rw] uuid
            #   @return [String] Alphanumeric UUID of a specific group call.
            attr_accessor :uuid

            # #!attribute [rw] url
            #   @return [String] URL that the recording is available at.
            attr_accessor :url

            # Construct a recording object from a UUID and a URL.
            #
            # @param [String] uuid (required) Alphanumeric UUID of the recording.
            # @param [String] url (required) URL the recording is available at.
            def initialize(uuid, url)
                # TODO
            end

        end

        # A participant in a call.
        class Participant

            #@!attribute [rw] id
            #   @return [Integer] Numeric ID of this participant.
            attr_accessor :id

            # @!attribute [rw] name
            #   @return [String] Name of this participant.
            attr_accessor :name

            # @!attribute [rw] number
            #   @return [String] Number of participant.
            attr_accessor :number

            # @!attribute [rw] calls
            #   @return [Array<SingleCall>] List of calls for this participant.
            attr_accessor :calls

            # Construct a participant object from a name and number.
            #
            # @param [String] number (required) Number of participant.
            # @param [String] name Name of participant.
            # @param [Integer] id Numeric ID of participant.
            # @param [Array<SingleCall>] calls List of calls for this participant.
            #
            # @raise [ArgumentError] A required argument is missing or an argument is invalid.
            #
            def initialize(number, name: nil, id: 0, calls: nil)
                # TODO validate

                @number = number
                @name   = name
                @id     = id
                @calls  = calls
            end

        end

        # A group call.
        class Call

            # @!attribute [rw] uuid
            #   @return [String] Alphanumeric UUID of a specific group call.
            attr_accessor :uuid

            # @!attribute [rw] participants
            #   @return [Array<Participant>] List of participants in the call.
            attr_accessor :participants

            # Construct an object describing a specific group call.
            #
            # @param [String] uuid (required) Alphanumeric UUID of this call.
            # @param [Array<Participant>] participants List of participants in the call.
            #
            # @raise [ArgumentError] A required argument is missing or an argument is invalid.
            #
            def initialize(uuid, participants: nil)
                # TODO
            end

        end

        # Construct a GroupCall object to make group calls using a specific endpoint.
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

        # Begin a group call to a set of participants.
        #
        # @param [String] name (required) Unique name for this call.
        # @param [Array<Participant>] participants (required) List of participants in the call.
        # @param [String] welcome_sound If provided, this sound will be played into each participant's call before
        #                               they are joined to the group call.
        # @param [String] wait_sound If provided, this sound will be played into a participant's call when there
        #                            are no other participants available on the call.
        # @param [String] start_call_on_enter If provided, no participants will be joined to the group call before
        #                                     this number answers the call.
        # @param [String] end_call_on_exit If provided, all participants will be disconnected when this number
        #                                  is disconnected or hangs up.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::       API UUID as a string.
        # Success::     `true` or `false` indicating the success or failure of the operation.
        # Message::     Message describing the action result.
        # GroupCall::   {Call} object describing the new group call.
        #
        # @raise [ArgumentError] Endpoint is not valid.
        #
        def initiate_group_call(name, participants, welcome_sound: nil, wait_sound: nil,
                                start_call_on_enter: nil, end_call_on_exit: nil)
            # TODO
        end

        # Retrieve the details about a group call.
        #
        # @param [String] call_uuid Alphanumeric UUID of the group call.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::       API UUID as a string.
        # Success::     `true` or `false` indicating the success or failure of the operation.
        # Message::     Message describing the action result.
        # GroupCall::   {Call} object describing the new group call, without any participants included.
        #
        # @raise [ArgumentError] Endpoint is not valid.
        #
        def get_group_call_details(call_uuid)
            # TODO
        end

        # Retrieve a collection of calls, optionally filtering by time and/or caller ID.
        # A limit may be specified to limit the returned collection to only a given number of
        # messages, and an offset may be specified to start the returned collection to the given
        # position in the total collection found.
        #
        # @param [DateTime] from Date/time of the earliest call to retrieve.
        # @param [DateTime] to Date/time of the latest call to retrieve.
        # @param [Integer] offset Position to start returning calls from. (default: 0)
        # @param [Integer] limit Maximum number of callss to return in one call. (default: 10)
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::       API UUID as a string.
        # Success::     `true` or `false` indicating the success or failure of the operation.
        # Message::     Message describing the action result.
        # GroupCalls::  Array of {Call} objects containing details of the matching calls.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def get_group_call_collection(from: nil, to: nil, offset: nil, limit: nil)
            # TODO
        end

        # Get details on a specific participant in a group call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::       API UUID as a string.
        # Success::     `true` or `false` indicating the success or failure of the operation.
        # Message::     Message describing the action result.
        # Participant:: {Participant} object describing the participant details.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_participant(call_uuid, participant_id)
            # TODO
        end

        # Get details on all participants in a group call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::           API UUID as a string.
        # Success::         `true` or `false` indicating the success or failure of the operation.
        # Message::         Message describing the action result.
        # Participants::    Array of {Participant} objects describing the participants.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_participants(call_uuid)
            # TODO
        end

        # Terminate a group call and disconnect all participants.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::                   API UUID as a string.
        # Success::                 `true` or `false` indicating the success or failure of the operation.
        # Message::                 Message describing the action result.
        # AffectedParticipantIds::  Array of numeric IDs of affected participants.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def terminate_group_call(call_uuid)
            # TODO
        end

        # Disconnect one participant from a group call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant to disconnect.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::                   API UUID as a string.
        # Success::                 `true` or `false` indicating the success or failure of the operation.
        # Message::                 Message describing the action result.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def terminate_participant(call_uuid, participant_id)
            # TODO
        end

        # Play a sound into a group call or into one participant's call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant to play the sound for, or
        #                                 `nil` if you wish to play the sound for all participants.
        # @param [String] sound_url (required) URL of the sound file to play.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::                   API UUID as a string.
        # Success::                 `true` or `false` indicating the success or failure of the operation.
        # Message::                 Message describing the action result.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def play_sound_into_call(call_uuid, participant_id, sound_url)
            # TODO handle all participants or specific participant
        end

        # Mute a participant in a group call, or mute all participants.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant to mute, or
        #                                 `nil` if you wish to mute all participants.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::                   API UUID as a string.
        # Success::                 `true` or `false` indicating the success or failure of the operation.
        # Message::                 Message describing the action result.
        # FailedParticipantIds::    Array of numeric IDs of participants who can't be muted. Present only when
        #                           muting all participants.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def mute_participants(call_uuid, participant_id)
            # TODO handle all participants or specific participant
        end

        # Unmute a participant in a group call, or unmute all participants.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant to unmute, or
        #                                 `nil` if you wish to unmute all participants.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::                   API UUID as a string.
        # Success::                 `true` or `false` indicating the success or failure of the operation.
        # Message::                 Message describing the action result.
        # FailedParticipantIds::    Array of numeric IDs of participants who can't be unmuted. Present only when
        #                           unmuting all participants.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def unmute_participants(call_uuid, participant_id)
            # TODO handle all participants or specific participant
        end

        # Start recording a group call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [String] file_format (required) Format to record in, either "mp3" or "wav".
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::       API UUID as a string.
        # Success::     `true` or `false` indicating the success or failure of the operation.
        # Message::     Message describing the action result.
        # Recording::   {Recording} object describing the details of the new recording.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def start_recording(call_uuid, file_format)
            # TODO
        end

        # Stop recording a group call, or stop all recordings of the call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [String] recording_uuid (required) Alphanumeric UUID of the recording to stop, or `nil`
        #                                to stop all recordings.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::                   API UUID as a string.
        # Success::                 `true` or `false` indicating the success or failure of the operation.
        # Message::                 Message describing the action result.
        # AffectedRecordingUUIDs::  Array of strings containing the UUIDs of recordings that were stopped. Present
        #                           only when all recordings are being stopped.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def stop_recording(call_uuid, recording_uuid)
            # TODO handle specific recording or all recordings
        end

        # Get the details of a recording of a call, or all recordings of a call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [String] recording_uuid (required) Alphanumeric UUID of the recording to retrieve, or `nil`
        #                                to retrieve details for all recordings.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # ApiId::       API UUID as a string.
        # Success::     `true` or `false` indicating the success or failure of the operation.
        # Message::     Message describing the action result.
        # Recording::   {Recording} object describing the recording. Present only when a single recording is
        #               being retrieved.
        # Recordings::  Array of {Recording} objects describing each recording. Present only when details of all
        #               recordings are being retrieved.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_recording_details(call_uuid, recording_uuid)
            # TODO handle specific recording or all recordings
        end

        # Delete one recording of a group call, or all recordings of the call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [String] recording_uuid (required) Alphanumeric UUID of the recording to delete, or `nil`
        #                                to delete all recordings.
        #
        # @return [Hash] Response attribute hash.
        #
        # === Response attribute hash items:
        # Success:: `true` or `false` indicating the success or failure of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def delete_recording(call_uuid, recording_uuid)
            # TODO handle specific recording or all recordings
        end

    end

end
