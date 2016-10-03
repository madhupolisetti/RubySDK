#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require 'rest-client'

module SmsCountryApi

    # Access to the `Calls` interface. Used to initiate and terminate calls, and to check on
    # call status.
    class Call

        # URL path component for calls.
        CALL_PATH      = "Calls"

        # URL path component for bulk calls.
        BULK_CALL_PATH = "BulkCalls"

        # region CallDetails class

        # Details of a call.
        class CallDetails

            # @!attribute [rw] number
            #   @return [String] Number dialed.
            attr_accessor :number

            # @!attribute [rw] call_uuid
            #   @return [String] Alphanumeric UUID of the call.
            attr_accessor :call_uuid

            # @!attribute [rw] caller_id
            #   @return [String] Caller ID displayed to the called party.
            attr_accessor :caller_id

            # @!attribute [rw] status
            #   @return [String] Call status.
            attr_accessor :status

            # @!attribute [rw] ring_time
            #   @return [Time] Time at which the call began ringing. May be nil if the call was
            #                  never connected and never started ringing.
            attr_accessor :ring_time

            # @!attribute [rw] answer_time
            #   @return [Time] Time at which the call was answered. May be nill if the call was
            #                  never answered.
            attr_accessor :answer_time

            # @!attribute [rw] end_time
            #   @return [Time] Time at which the call was terminated or disconnected. May be nil if
            #                  the call was never connected.
            attr_accessor :end_time

            # @!attribute [rw] end_reason
            #   @return [String] Reason for call termination.
            attr_accessor :end_reason

            # @!attribute [rw] cost
            #   @return [String] Cost of the call.
            attr_accessor :cost

            # @!attribute [rw] direction
            #   @return [String] Direction of the call, inbound or outbound.
            attr_accessor :direction

            # @!attribute [rw] pulse
            #   @return [Integer] Number of seconds per pulse.
            attr_accessor :pulse

            # @!attribute [rw] pulses
            #   @return [Integer] Number of pulses in the call.
            attr_accessor :pulses

            # @!attribute [rw] price_per_pulse
            #   @return [Float] Price per pulse of the call.
            attr_accessor :price_per_pulse

            # Construct a new blank call details object.
            #
            def initialize
                @number          = nil
                @call_uuid       = nil
                @caller_id       = nil
                @status          = nil
                @ring_time       = nil
                @answer_time     = nil
                @end_time        = nil
                @end_reason      = nil
                @cost            = nil
                @direction       = nil
                @pulse           = nil
                @pulses          = nil
                @price_per_pulse = nil
            end

            # Construct a new call details object from the provided arguments
            #
            # @param [String] number Number of participant.
            # @param [String] call_uuid Alphanumeric UUID of the call.
            # @param [String] caller_id Caller ID information.
            # @param [String] status Status of call.
            # @param [Time] ring_time Time the call began ringing.
            # @param [Time] answer_time Time the call was answered.
            # @param [Time] end_time Time the call ended.
            # @param [String] end_reason Reason the call ended.
            # @param [String] cost Cost of the call.
            # @param [String] direction Direction of the call.
            # @param [Integer] pulse Number of seconds per pulse.
            # @param [Integer] pulses Number of pulses in the call.
            # @param [Float] price_per_pulse Price per pulse of the call.
            #
            # @return [{CallDetails}] New call details object.
            #
            # @raise [ArgumentError] An argument is missing or invalid.
            #
            def self.create(number, call_uuid, caller_id: nil, status: nil, ring_time: nil, answer_time: nil,
                end_time: nil, end_reason: nil, cost: nil, direction: nil, pulse: nil, pulses: nil,
                price_per_pulse: nil)
                if number.nil? || !number.kind_of?(String) || number.empty?
                    raise ArgumentError, "Number must be a non-empty string."
                end
                if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                    raise ArgumentError, "Call UUID must be a non-empty string."
                end
                if (!caller_id.nil? && !caller_id.kind_of?(String)) ||
                    (!status.nil? && !status.kind_of?(String)) ||
                    (!ring_time.nil? && !ring_time.kind_of?(Time)) ||
                    (!answer_time.nil? && !answer_time.kind_of?(Time)) ||
                    (!end_time.nil? && !end_time.kind_of?(Time)) ||
                    (!end_reason.nil? && !end_reason.kind_of?(String)) ||
                    (!cost.nil? && !cost.kind_of?(String)) ||
                    (!direction.nil? && !direction.kind_of?(String)) ||
                    (!pulse.nil? && !pulse.kind_of?(Integer)) ||
                    (!pulses.nil? && !pulses.kind_of?(Integer)) ||
                    (!price_per_pulse.nil? && !price_per_pulse.kind_of?(Float))
                    raise ArgumentError, "Invalid argument type."
                end

                obj                 = CallDetails.new
                obj.number          = number
                obj.call_uuid       = call_uuid
                obj.caller_id       = caller_id
                obj.status          = status
                obj.ring_time       = ring_time
                obj.answer_time     = answer_time
                obj.end_time        = end_time
                obj.end_reason      = end_reason
                obj.cost            = cost
                obj.direction       = direction
                obj.pulse           = pulse
                obj.pulses          = pulses
                obj.price_per_pulse = price_per_pulse
                obj
            end

            # Construct a new call details object from a hash returned by the API.
            #
            # @param [Hash] hash Hash from the response.
            #
            # @return [{CallDetails}] New call details object.
            #
            def self.from_hash(hash)
                if hash.nil? || !hash.kind_of?(Hash)
                    raise ArgumentError, "Argument must be a hash."
                end
                obj = CallDetails.new
                hash.each do |k, v|
                    case k
                    when 'Number' then
                        obj.number = CGI.unescape(v) unless v.nil?
                    when 'CallUUID' then
                        obj.call_uuid = CGI.unescape(v) unless v.nil?
                    when 'CallerId' then
                        obj.caller_id = CGI.unescape(v) unless v.nil?
                    when 'Status' then
                        obj.status = CGI.unescape(v) unless v.nil?
                    when 'RingTime' then
                        obj.ring_time = Time.at(CGI.unescape(v).to_i) unless v.nil?
                    when 'AnswerTime' then
                        obj.answer_time = Time.at(CGI.unescape(v).to_i) unless v.nil?
                    when 'EndTime' then
                        obj.end_time = Time.at(CGI.unescape(v).to_i) unless v.nil?
                    when 'EndReason' then
                        obj.end_reason = CGI.unescape(v) unless v.nil?
                    when 'Cost' then
                        obj.cost = CGI.unescape(v) unless v.nil?
                    when 'Direction' then
                        obj.direction = CGI.unescape(v) unless v.nil?
                    when 'Pulse' then
                        obj.pulse = CGI.unescape(v).to_i unless v.nil?
                    when 'Pulses' then
                        obj.pulses = CGI.unescape(v).to_i unless v.nil?
                    when 'PricePerPulse' then
                        obj.price_per_pulse = CGI.unescape(v).to_f unless v.nil?
                    end
                end
                obj
            end

        end

        # endregion CallDetails class

        # Construct a Call object to make calls using a specific endpoint.
        #
        # @param [{Endpoint}] endpoint (required) Endpoint object to use for service URL and authentication parameters.
        #
        # @raise [ArgumentError] Endpoint is not valid.
        #
        def initialize(endpoint)
            if endpoint.nil? || !endpoint.kind_of?(Endpoint)
                raise ArgumentError, "A valid endpoint must be supplied."
            end

            @endpoint = endpoint
        end

        # Create and initiate a new call to a single number.
        #
        # @param [String] number (required) number to call.
        # @param [String] caller_id Caller ID number to display to the called party.
        # @param [String] ring_url URL to be notified as soon as the call begins ringing.
        # @param [String] answer_url URL to be notified as soon as the call is answered.
        # @param [String] hangup_url URL to be notified as soon as the called party hangs up or is disconnected. If
        #                            not provided, `answer_url` will be used.
        # @param [String] http_method HTTP method to be used for notification requests.
        # @param [String] xml XML specifying content to be played into the call.
        #
        # @return [Array({StatusResponse}, String)]
        #   - Status of the operation.
        #   - Alphanumeric UUID identifying the call.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def initiate_call(number, caller_id: nil, ring_url: nil, answer_url: nil, hangup_url: nil,
                          http_method: nil, xml: nil)
            if number.nil? || !number.kind_of?(String) || number.empty?
                raise ArgumentError, "Number must be supplied."
            end

            url     = @endpoint.url + CALL_PATH + '/'
            headers = {
                content_type:  'application/json',
                accept:        'application/json',
                authorization: @endpoint.authorization
            }

            values               = { 'Number' => number }
            values['CallerId']   = caller_id unless caller_id.nil?
            values['RingUrl']    = ring_url unless ring_url.nil?
            values['AnswerUrl']  = answer_url unless answer_url.nil?
            values['HangupUrl']  = hangup_url unless hangup_url.nil?
            values['HttpMethod'] = http_method unless http_method.nil?
            values['Xml']        = xml unless xml.nil?

            call_uuid = nil
            begin
                response = RestClient.post url, values, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    call_uuid      = result['CallUUID']
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, call_uuid
        end

        # Create and initiate a new call to a list of numbers. If only one number is
        # provided, it will be processed as a normal {#initiate_call} operation.
        #
        # @param [Array<String>] number_list (required) List of numbers to call.
        # @param [String] caller_id Caller ID number to display to the called party.
        # @param [String] ring_url URL to be notified as soon as the call begins ringing.
        # @param [String] answer_url URL to be notified as soon as the call is answered.
        # @param [String] hangup_url URL to be notified as soon as the called party hangs up or is disconnected. If
        #                            not provided, `answer_url` will be used.
        # @param [String] http_method HTTP method to be used for notification requests.
        # @param [String] xml XML specifying content to be played into the call.
        #
        # @return [Array({StatusResponse}, Array<String>)]
        #   - Status of the operation.
        #   - Array of alphanumeric UUIDs identifying the calls.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def initiate_bulk_call(number_list, caller_id: nil, ring_url: nil, answer_url: nil, hangup_url: nil,
                               http_method: nil, xml: nil)
            if number_list.nil? || !number_list.kind_of?(Array) || number_list.empty?
                raise ArgumentError, "List of numbers in an array must be supplied."
            end

            url     = @endpoint.url + BULK_CALL_PATH + '/'
            headers = {
                content_type:  'application/json',
                accept:        'application/json',
                authorization: @endpoint.authorization
            }

            values               = { 'Numbers' => number_list }
            values['CallerId']   = caller_id unless caller_id.nil?
            values['RingUrl']    = ring_url unless ring_url.nil?
            values['AnswerUrl']  = answer_url unless answer_url.nil?
            values['HangupUrl']  = hangup_url unless hangup_url.nil?
            values['HttpMethod'] = http_method unless http_method.nil?
            values['Xml']        = xml unless xml.nil?

            call_uuids = nil
            begin
                response = RestClient.post url, values, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    call_uuids     = result['CallUUIDs']
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, call_uuids
        end

        # Terminate a specific call and hang up.
        #
        # @param [String] call_uuid Alphanumeric UUID of the call to terminate.
        #
        # @return [Array({StatusResponse})]
        #   - Status of the operation.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def terminate_call(call_uuid)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end

            url     = @endpoint.url + CALL_PATH + '/' + CGI.escape(call_uuid) + "/"
            headers = {
                content_type:  'application/json',
                accept:        'application/json',
                authorization: @endpoint.authorization
            }

            begin
                response = RestClient.patch url, '', headers
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

        # Get details on a specific call.
        #
        # @param [String] call_uuid Alphanumeric UUID of the call to retrieve details of.
        #
        # @return [Array({StatusResponse}, {CallDetails})]
        #   - Status of the operation.
        #   - Call details object for the call.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def get_details(call_uuid)
            if call_uuid.nil? || !call_uuid.kind_of?(String) || call_uuid.empty?
                raise ArgumentError, "Call UUID must be a non-empty string."
            end

            url     = @endpoint.url + CALL_PATH + '/' + CGI.escape(call_uuid) + "/"
            headers = {
                content_type:  'application/json',
                accept:        'application/json',
                authorization: @endpoint.authorization
            }

            details = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    details_hash   = result['Call']
                    if !details_hash.nil?
                        details = CallDetails.from_hash(details_hash)
                    else
                        status = StatusResponse.new(false, "No details included in response.")
                    end
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, details
        end

        # Retrieve a collection of calls, optionally filtering by time and/or caller ID.
        # A limit may be specified to limit the returned collection to only a given number of
        # messages, and an offset may be specified to start the returned collection to the given
        # position in the total collection found.
        #
        # @param [DateTime] from Date/time of the earliest message to retrieve.
        # @param [DateTime] to Date/time of the latest message to retrieve.
        # @param [String] caller_id Caller ID to retrieve messages for.
        # @param [Integer] offset Position to start returning messages from. (default: 0)
        # @param [Integer] limit Maximum number of messages to return in one call. (default: 10)
        #
        # @return [Array({StatusResponse}, Array<{CallDetails}>)]
        #   - Status of the operation.
        #   - Array of call details objects matching the criteria.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def get_collection(from: nil, to: nil, caller_id: nil, offset: nil, limit: nil)
            if !from.nil? && !from.kind_of?(Time)
                raise ArgumentError, "From argument must be a time."
            end
            if !to.nil? && !to.kind_of?(Time)
                raise ArgumentError, "To argument must be a time."
            end
            if !caller_id.nil? && (!caller_id.kind_of?(String) || caller_id.empty?)
                raise ArgumentError, "Caller ID argument must be a non-empty string."
            end
            if !offset.nil? && !offset.kind_of?(Numeric)
                raise ArgumentError, "Offset argument must be a number."
            end
            if !limit.nil? && !limit.kind_of?(Numeric)
                raise ArgumentError, "Limit argument must be a number."
            end

            url          = @endpoint.url + CALL_PATH + '/'
            query_string = ""
            query_string += '&FromDate=' + CGI.escape(from.strftime('%Y-%m-%d %H:%M:%S')) unless from.nil?
            query_string += '&ToDate=' + CGI.escape(to.strftime('%Y-%m-%d %H:%M:%S')) unless to.nil?
            query_string += '&CallerId=' + CGI.escape(caller_id) unless caller_id.nil?
            query_string += '&Offset=' + offset.to_s unless offset.nil?
            query_string += '&Limit=' + limit.to_s unless limit.nil?
            unless query_string.empty?
                query_string[0] = '?'
                url             += query_string
            end
            headers = {
                content_type:  'application/json',
                accept:        'application/json',
                authorization: @endpoint.authorization
            }

            returned_detail_list = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    details_list   = result['Calls']
                    if !details_list.nil?
                        returned_detail_list = []
                        details_list.each do |details_hash|
                            details = CallDetails.from_hash(details_hash)
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

    end

end
