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

        # region Recording class

        # A recording of a call.
        class Recording

            # @!attribute [rw] uuid
            #   @return [String] Alphanumeric UUID of a specific group call.
            attr_accessor :uuid

            # #!attribute [rw] url
            #   @return [String] URL that the recording is available at.
            attr_accessor :url

            # Construct a blank recording object.
            #
            def initialize
                @uuid = nil
                @url  = nil
            end

            # Returns a hash representing the object.
            #
            # @return [Hash] Resulting hash.
            #
            def to_hash
                hash                  = {}
                hash['RecordingUUID'] = @uuid unless @uuid.nil?
                hash['Url']           = @url unless @url.nil?
                hash
            end

            # Construct a recording object from a UUID and a URL.
            #
            # @param [String] uuid (required) Alphanumeric UUID of the recording.
            # @param [String] url (required) URL the recording is available at.
            #
            # @return [{Recording}] New recording object.
            #
            # @raise [ArgumentError] An argument is missing or invalid.
            #
            def self.create(uuid, url)
                if (uuid.nil? || !uuid.kind_of?(String) || uuid.empty?) ||
                    (url.nil? || !url.kind_of?(String) || url.empty?)
                    raise ArgumentError, "UUID and URL must be non-empty strings."
                end

                obj      = Recording.new
                obj.uuid = uuid
                obj.url  = url
                obj
            end

            # Construct a new Recording object from a hash returned by the API.
            #
            # @param [Hash] hash Hash from the response.
            #
            # @return [{Recording}] New recording object.
            #
            def self.from_hash(hash)
                if hash.nil? || !hash.kind_of?(Hash)
                    raise ArgumentError, "Argument must be a hash."
                end
                obj = Recording.new
                hash.each do |k, v|
                    case k
                    when 'RecordingUUID' then
                        obj.uuid = CGI.unescape(v) unless v.nil?
                    when 'Url' then
                        obj.url = CGI.unescape(v) unless v.nil?
                    end
                end
                obj
            end

        end

        # endregion Recording class

        # region Participants class

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
            #   @return [Array<{Call::CallDetails}>] List of calls for this participant.
            attr_accessor :calls

            # Construct a new blank object.
            #
            def initialize
                @id     = nil
                @name   = nil
                @number = nil
                @calls  = nil
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
                unless @calls.nil?
                    l = []
                    @calls.each do |call|
                        l.push(call.to_hash)
                    end
                    hash['Calls'] = l
                end
                hash
            end

            # Construct a participant object from a name and number.
            #
            # @param [String] number (required) Number of participant.
            # @param [String] name Name of participant.
            # @param [Integer] id Numeric ID of participant.
            # @param [Array<{Call::CallDetails}>] calls List of calls for this participant.
            #
            # @return [{Participant}] New participant object.
            #
            # @raise [ArgumentError] A required argument is missing or an argument is invalid.
            #
            def self.create(number, name: nil, id: nil, calls: nil)
                if number.nil? || !number.kind_of?(String) || number.empty?
                    raise ArgumentError, "Number must be a non-empty string."
                end
                if (!name.nil? && !name.kind_of?(String)) ||
                    (!id.nil? && !id.kind_of?(Integer)) ||
                    (!calls.nil? && !calls.kind_of?(Array))
                    raise ArgumentError, "Illegal argument type."
                end

                obj        = Participant.new
                obj.number = number
                obj.name   = name
                obj.id     = id
                obj.calls  = calls
                obj
            end

            # Construct a new Participant object from a hash returned by the API.
            #
            # @param [Hash] hash Hash from the response.
            #
            # @return [{Participant}] New participant object.
            #
            def self.from_hash(hash)
                if hash.nil? || !hash.kind_of?(Hash)
                    raise ArgumentError, "Argument must be a hash."
                end
                obj = Participant.new
                hash.each do |k, v|
                    case k
                    when 'Number' then
                        obj.number = CGI.unescape(v) unless v.nil?
                    when 'Name' then
                        obj.name = CGI.unescape(v) unless v.nil?
                    when 'Id' then
                        obj.id = v unless v.nil?
                    when 'Calls' then
                        call_list = []
                        v.each do |p|
                            call_list.push(Call::CallDetails.from_hash(p))
                        end
                        unless call_list.empty?
                            obj.calls = call_list
                        end
                    end
                end
                obj
            end

        end

        # endregion Participant class

        # region GroupCallDetails class

        # Details of a group call.
        class GroupCallDetails

            # @!attribute [rw] uuid
            #   @return [String] Alphanumeric UUID of a specific group call.
            attr_accessor :uuid

            # @!attribute [rw] name
            #   @return [String] Name of the group call.
            attr_accessor :name

            # @!attribute [rw] welcome_sound
            #   @return [String] Sound to play when a participant enters the call.
            attr_accessor :welcome_sound

            # @!attribute [rw] wait_sound
            #   @return [String] Sound to play when a participant must wait for the call to start.
            attr_accessor :wait_sound

            # @!attribute [rw] start_call_on_enter
            #   @return [String] If specified, a group call will not be started until this number answers the call.
            attr_accessor :start_call_on_enter

            # @!attribute [rw] end_call_on_exit
            #   @return [String] If specified, a group call will terminate when this number is disconnected or hangs up.
            attr_accessor :end_call_on_exit

            # @!attribute [rw] participants
            #   @return [Array<Participant>] List of participants in the call.
            attr_accessor :participants

            # Construct a new blank object.
            #
            def initialize
                @uuid                = nil
                @name                = nil
                @welcome_sound       = nil
                @wait_sound          = nil
                @start_call_on_enter = nil
                @end_call_on_exit    = nil
                @participants        = nil
            end

            # Returns a hash representing the object.
            #
            # @return [Hash] Resulting hash.
            #
            def to_hash
                hash                          = {}
                hash['GroupCallUUID']         = @uuid unless @uuid.nil?
                hash['Name']                  = @name unless @name.nil?
                hash['WelcomeSound']          = @welcome_sound unless @welcome_sound.nil?
                hash['WaitSound']             = @wait_sound unless @wait_sound.nil?
                hash['StartGroupCallOnEnter'] = @start_call_on_enter unless @start_call_on_enter.nil?
                hash['EndGroupCallOnExit']    = @end_call_on_exit unless @end_call_on_exit.nil?
                unless @participants.nil?
                    participant_list = []
                    @participants.each do |participant|
                        participant_list.push(participant.to_hash)
                    end
                    hash['Participants'] = participant_list
                end
                hash
            end

            # Construct an object describing a specific group call.
            #
            # @param [String] uuid (required) Alphanumeric UUID of this call.
            # @param [Array<Participant>] participants List of participants in the call.
            #
            # @return [{GroupCallDetails}] New Call object.
            #
            # @raise [ArgumentError] A required argument is missing or an argument is invalid.
            #
            def self.create(uuid, name: nil, welcome_sound: nil, wait_sound: nil,
                start_call_on_enter: nil, end_call_on_exit: nil, participants: nil)
                if uuid.nil? || !uuid.kind_of?(String) || uuid.empty?
                    raise ArgumentError, "UUID must be a non-empty string."
                end
                if (!name.nil? && !name.kind_of?(String)) ||
                    (!welcome_sound.nil? && !welcome_sound.kind_of?(String)) ||
                    (!wait_sound.nil? && !wait_sound.kind_of?(String)) ||
                    (!start_call_on_enter.nil? && !start_call_on_enter.kind_of?(String)) ||
                    (!end_call_on_exit.nil? && !end_call_on_exit.kind_of?(String)) ||
                    (!participants.nil? && !participants.kind_of?(Array))
                    raise ArgumentError, "Illegal argument type."
                end

                obj                     = GroupCallDetails.new
                obj.uuid                = uuid
                obj.name                = name unless name.nil?
                obj.welcome_sound       = welcome_sound unless welcome_sound.nil?
                obj.wait_sound          = wait_sound unless wait_sound.nil?
                obj.start_call_on_enter = start_call_on_enter unless start_call_on_enter.nil?
                obj.end_call_on_exit    = end_call_on_exit unless end_call_on_exit.nil?
                obj.participants        = participants unless participants.nil?
                obj
            end

            # Construct a new group call detail object from a hash returned by the API.
            #
            # @param [Hash] hash Hash from the response.
            #
            # @return [{GroupCallDetails}] New group call object.
            #
            def self.from_hash(hash)
                if hash.nil? || !hash.kind_of?(Hash)
                    raise ArgumentError, "Argument must be a hash."
                end
                obj = GroupCallDetails.new
                hash.each do |k, v|
                    case k
                    when 'GroupCallUUID' then
                        obj.uuid = CGI.unescape(v) unless v.nil?
                    when 'Name' then
                        obj.name = CGI.unescape(v) unless v.nil?
                    when 'WelcomeSound' then
                        obj.welcome_sound = CGI.unescape(v) unless v.nil?
                    when 'WaitSound' then
                        obj.wait_sound = CGI.unescape(v) unless v.nil?
                    when 'StartGroupCallOnEnter' then
                        obj.start_call_on_enter = CGI.unescape(v) unless v.nil?
                    when 'EndGroupCallOnExit' then
                        obj.end_call_on_exit = CGI.unescape(v) unless v.nil?
                    when 'Participants' then
                        unless v.nil?
                            participant_list = []
                            v.each do |p|
                                participant_list.push(Participant.from_hash(p))
                            end
                            unless participant_list.empty?
                                obj.participants = participant_list
                            end
                        end
                    end
                end
                obj
            end

        end

        # endregion GroupCallDetails class

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
        # @return [Array({StatusResponse}, {GroupCallDetails})]
        #   - Status of the operation.
        #   - {GroupCallDetails} object describing the newly-created group call.
        #
        # @raise [ArgumentError] Endpoint is not valid.
        #
        def initiate_group_call(name, participants, welcome_sound: nil, wait_sound: nil,
                                start_call_on_enter: nil, end_call_on_exit: nil)
            if name.nil? || !name.kind_of?(String) || name.empty?
                raise ArgumentError, "Name must be a non-empty string."
            end
            if participants.nil? || !participants.kind_of?(Array) || participants.empty?
                raise ArgumentError, "Participant list must be a non-empty array."
            end
            if (!welcome_sound.nil? && !welcome_sound.kind_of?(String)) ||
                (!wait_sound.nil? && !wait_sound.kind_of?(String)) ||
                (!start_call_on_enter.nil? && !start_call_on_enter.kind_of?(String)) ||
                (!end_call_on_exit.nil? && !end_call_on_exit.kind_of?(String))
                raise ArgumentError, "Invalid argument type."
            end

            url     = @endpoint.url + GROUP_CALL_PATH + '/'
            headers = @endpoint.headers

            values                          = { 'Name' => name, 'Participants' => participants }
            values['WelcomeSound']          = welcome_sound unless welcome_sound.nil?
            values['WaitSound']             = wait_sound unless wait_sound.nil?
            values['StartGroupCallOnEnter'] = start_call_on_enter unless start_call_on_enter.nil?
            values['EndGroupCallOnExit']    = end_call_on_exit unless end_call_on_exit.nil?

            call_details = nil
            begin
                response = RestClient.post url, values.to_json, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['GroupCall']
                    call_details   = GroupCallDetails.from_hash(hash) unless hash.nil?
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, call_details
        end

        # Retrieve the details about a group call.
        #
        # @param [String] call_uuid Alphanumeric UUID of the group call.
        #
        # @return [Array({StatusResponse}, {GroupCallDetails})]
        #   - Status of the operation.
        #   - {GroupCallDetails} object describing the group call.
        #
        # @raise [ArgumentError] Endpoint is not valid.
        #
        def get_group_call_details(call_uuid)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end

            url     = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + "/"
            headers = @endpoint.headers

            call_details = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['GroupCall']
                    call_details   = GroupCallDetails.from_hash(hash) unless hash.nil?
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, call_details
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
        # @return [Array({StatusResponse}, Array<{GroupCallDetails}>)]
        #   - Status of the operation.
        #   - Array of {GroupCallDetails} objects containing details of the matching calls.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def get_group_call_collection(from: nil, to: nil, offset: nil, limit: nil)
            if !from.nil? && !from.kind_of?(Time)
                raise ArgumentError, "From argument must be a time."
            end
            if !to.nil? && !to.kind_of?(Time)
                raise ArgumentError, "To argument must be a time."
            end
            if !offset.nil? && !offset.kind_of?(Numeric)
                raise ArgumentError, "Offset argument must be a number."
            end
            if !limit.nil? && !limit.kind_of?(Numeric)
                raise ArgumentError, "Limit argument must be a number."
            end

            url          = @endpoint.url + GROUP_CALL_PATH + '/'
            query_string = ''
            query_string += '&FromDate=' + CGI.escape(from.strftime('%Y-%m-%d %H:%M:%S')) unless from.nil?
            query_string += '&ToDate=' + CGI.escape(to.strftime('%Y-%m-%d %H:%M:%S')) unless to.nil?
            query_string += '&Offset=' + offset.to_s unless offset.nil?
            query_string += '&Limit=' + limit.to_s unless limit.nil?
            unless query_string.empty?
                query_string[0] = '?'
                url             += query_string
            end
            headers = @endpoint.headers

            returned_detail_list = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    details_list   = result['GroupCalls']
                    if !details_list.nil?
                        returned_detail_list = []
                        details_list.each do |details_hash|
                            details = GroupCallDetails.from_hash(details_hash)
                            returned_detail_list.push details
                        end
                    else
                        status = StatusResponse.new(false, "No list of call details included in response.")
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, returned_detail_list
        end

        # Get details on a specific participant in a group call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant.
        #
        # @return [Array({StatusResponse}, {Participant})]
        #   - Status of the operation.
        #   - {Participant} object describing the participant details.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_participant(call_uuid, participant_id)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if participant_id.nil? || !participant_id.kind_of?(Integer)
                raise ArgumentError, "Participant ID must be an integer."
            end

            url     = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/' +
                PARTICIPANTS_PATH + '/' + participant_id.to_s + '/'
            headers = @endpoint.headers

            participant_details = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result      = StatusResponse.from_response(response)
                    hash                = result['Participant']
                    participant_details = Participant.from_hash(hash) unless hash.nil?
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, participant_details
        end

        # Get details on all participants in a group call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        #
        # @return [Array({StatusResponse}, Array<{Participant}>)]
        #   - Status of the operation.
        #   - Array of {Participant} objects describing the participants.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_participants(call_uuid)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end

            url     = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/' + PARTICIPANTS_PATH + '/'
            headers = @endpoint.headers

            participant_detail_list = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['Participants']
                    if !hash.nil?
                        participant_detail_list = []
                        hash.each do |details_hash|
                            details = Participant.from_hash(details_hash)
                            participant_detail_list.push details
                        end
                    else
                        status = StatusResponse.new(false, "No list of participants included in response.")
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, participant_detail_list
        end

        # Terminate a group call and disconnect all participants.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        #
        # @return [Array({StatusResponse}, Array<Integer>)]
        #   - Status of the operation.
        #   - Array of numeric IDs of affected participants.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def terminate_group_call(call_uuid)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end

            url     = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/' + HANGUP_PATH + '/'
            headers = @endpoint.headers

            affected_participants = nil
            begin
                response = RestClient.patch url, nil, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['AffectedParticipantIds']
                    if !hash.nil?
                        affected_participants = []
                        hash.each do |id|
                            affected_participants.push(id)
                        end
                    else
                        status = StatusResponse.new(false, "No list of participant IDs included in response.")
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, affected_participants
        end

        # Disconnect one participant from a group call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant to disconnect.
        #
        # @return [Array({StatusResponse})]
        #   - Status of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def terminate_participant(call_uuid, participant_id)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if participant_id.nil? || !participant_id.kind_of?(Integer)
                raise ArgumentError, "Participant ID must be an integer."
            end

            url     = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/' +
                PARTICIPANTS_PATH + '/' + participant_id.to_s + '/' + HANGUP_PATH + '/'
            headers = @endpoint.headers

            begin
                response = RestClient.patch url, nil, headers
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

        # Play a sound into a group call or into one participant's call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant to play the sound for, or
        #                                 `nil` if you wish to play the sound for all participants.
        # @param [String] sound_url (required) URL of the sound file to play.
        #
        # @return [Array({StatusResponse})]
        #   - Status of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def play_sound_into_call(call_uuid, participant_id, sound_url)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if !participant_id.nil? && !participant_id.kind_of?(Integer)
                raise ArgumentError, "Participant ID must be an integer or nil."
            end
            if sound_url.nil? || !sound_url.kind_of?(String) || sound_url.empty?
                raise ArgumentError, "Sound URL must be a non-empty string"
            end

            url = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/'
            unless participant_id.nil?
                url += PARTICIPANTS_PATH + '/' + participant_id.to_s + '/'
            end
            url     += PLAY_PATH + '/'
            headers = @endpoint.headers

            values = { 'File' => sound_url }

            begin
                response = RestClient.post url, values.to_json, headers
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

        # Mute a participant in a group call, or mute all participants.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant to mute, or
        #                                 `nil` if you wish to mute all participants.
        #
        # @return [Array({StatusResponse}, Array<Integer>)]
        #   - Status of the operation.
        #   - Array of numeric IDs of participants who can't be muted. Present only when
        #     muting all participants, will be `nil` otherwise.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def mute_participant(call_uuid, participant_id)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if !participant_id.nil? && !participant_id.kind_of?(Integer)
                raise ArgumentError, "Participant ID must be an integer or nil."
            end

            url = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/'
            unless participant_id.nil?
                url += PARTICIPANTS_PATH + '/' + participant_id.to_s + '/'
            end
            url     += MUTE_PATH + '/'
            headers = @endpoint.headers

            failed_participants = nil
            begin
                response = RestClient.patch url, nil, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['FailedParticipantIds']
                    if !hash.nil?
                        failed_participants = []
                        hash.each do |id|
                            failed_participants.push(id)
                        end
                    elsif participant_id.nil?
                        status = StatusResponse.new(false, "No list of participant IDs included in response.")
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, failed_participants
        end

        # Unmute a participant in a group call, or unmute all participants.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [Integer] participant_id (required) Numeric ID of the participant to unmute, or
        #                                 `nil` if you wish to unmute all participants.
        #
        # @return [Array({StatusResponse}, Array<Integer>)]
        #   - Status of the operation.
        #   - Array of numeric IDs of participants who can't be unmuted. Present only when
        #     unmuting all participants, will be `nil` otherwise.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def unmute_participant(call_uuid, participant_id)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if !participant_id.nil? && !participant_id.kind_of?(Integer)
                raise ArgumentError, "Participant ID must be an integer or nil."
            end

            url = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/'
            unless participant_id.nil?
                url += PARTICIPANTS_PATH + '/' + participant_id.to_s + '/'
            end
            url     += UNMUTE_PATH + '/'
            headers = @endpoint.headers

            failed_participants = nil
            begin
                response = RestClient.patch url, nil, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['FailedParticipantIds']
                    if !hash.nil?
                        failed_participants = []
                        hash.each do |id|
                            failed_participants.push(id)
                        end
                    elsif participant_id.nil?
                        status = StatusResponse.new(false, "No list of participant IDs included in response.")
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, failed_participants
        end

        # Start recording a group call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [String] file_format (required) Format to record in, either "mp3" or "wav".
        #
        # @return [Array({StatusResponse}, {Recording})]
        #   - Status of the operation.
        #   - {Recording} object describing the details of the new recording.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def start_recording(call_uuid, file_format)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if file_format.nil? || !file_format.kind_of?(String) || file_format.empty?
                raise ArgumentError, "File format must be a non-empty string."
            end

            url     = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/' + RECORDING_PATH + '/'
            headers = @endpoint.headers

            values = { 'FileFormat' => file_format }

            recording_details = nil
            begin
                response = RestClient.post url, values.to_json, headers
                if !response.nil?
                    status, result    = StatusResponse.from_response(response)
                    hash              = result['Recording']
                    recording_details = Recording.from_hash(hash) unless hash.nil?
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, recording_details
        end

        # Stop recording a group call, or stop all recordings of the call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [String] recording_uuid (required) Alphanumeric UUID of the recording to stop, or `nil`
        #                                to stop all recordings.
        #
        # @return [Array({StatusResponse}, Array<String>)]
        #   - Status of the operation.
        #   - Array of strings containing the UUIDs of recordings that were stopped. Present
        #     only when all recordings are being stopped, will be `nil` otherwise.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def stop_recording(call_uuid, recording_uuid)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if !recording_uuid.nil? && (!recording_uuid.kind_of?(String) || recording_uuid.empty?)
                raise ArgumentError, "Recording UUID must be a non-empty string or nil."
            end

            url = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/' + RECORDING_PATH + '/'
            unless recording_uuid.nil?
                url += CGI.escape(recording_uuid) + '/'
            end
            headers = @endpoint.headers

            recording_uuids = nil
            begin
                response = RestClient.patch url, nil, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    hash           = result['AffectedRecordingUUIDs']
                    if !hash.nil?
                        recording_uuids = []
                        hash.each do |uuid|
                            recording_uuids.push(uuid)
                        end
                    elsif recording_uuid.nil?
                        status = StatusResponse.new(false, "No list of recording UUIDs included in response.")
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, recording_uuids
        end

        # Get the details of a recording of a call, or all recordings of a call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [String] recording_uuid (required) Alphanumeric UUID of the recording to retrieve, or `nil`
        #                                to retrieve details for all recordings.
        #
        # @return [Array({StatusResponse}, {Recording})]
        #   - Status of the operation.
        #   - {Recording} object describing the recording, if a single recording is being retrieved.
        #
        # @return [Array({StatusResponse}, Array<{Recording}>)]
        #   - Status of the operation.
        #   - Array of {Recording} objects describing each recording, if all recording are being retrieved.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_recording_details(call_uuid, recording_uuid)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if !recording_uuid.nil? && (!recording_uuid.kind_of?(String) || recording_uuid.empty?)
                raise ArgumentError, "Recording UUID must be a non-empty string or nil."
            end

            url = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/' + RECORDING_PATH + '/'
            unless recording_uuid.nil?
                url += CGI.escape(recording_uuid) + '/'
            end
            headers = @endpoint.headers

            results = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    if recording_uuid.nil?
                        hash = result['Recordings']
                        unless hash.nil?
                            results = []
                            hash.each do |recording|
                                results.push(Recording.from_hash(recording))
                            end
                        end
                    else
                        hash    = result['Recording']
                        results = Recording.from_hash(hash) unless hash.nil?
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, results
        end

        # Delete one recording of a group call, or all recordings of the call.
        #
        # @param [String] call_uuid (required) Alphanumeric UUID of the group call.
        # @param [String] recording_uuid (required) Alphanumeric UUID of the recording to delete, or `nil`
        #                                to delete all recordings.
        #
        # @return [Array({StatusResponse})]
        #   - Status of the operation.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def delete_recording(call_uuid, recording_uuid)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end
            if !recording_uuid.nil? && (!recording_uuid.kind_of?(String) || recording_uuid.empty?)
                raise ArgumentError, "Recording UUID must be a non-empty string or nil."
            end

            url = @endpoint.url + GROUP_CALL_PATH + '/' + CGI.escape(call_uuid) + '/' + RECORDING_PATH + '/'
            unless recording_uuid.nil?
                url += CGI.escape(recording_uuid) + '/'
            end
            headers = @endpoint.headers

            begin
                response = RestClient.delete url, headers
                if response.code / 100 == 2
                    status = StatusResponse.new(true)
                else
                    status = StatusResponse.new(false, "HTTP status code #{response.code}")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            [status]
        end

    end

end
