#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require 'rest-client'

module SmsCountryApi

    # Access to the `SMSes` interface. Used to send SMS messages and check on their status.
    class SMS

        # URL path component for SMS access.
        SMS_PATH      = 'SMSes'

        # URL path component for bulk SMS access.
        BULK_SMS_PATH = 'BulkSMSes'

        # region SmsDetails class

        # Details of a single SMS message.
        class SmsDetails

            # @!attribute [rw] message_uuid
            #   @return [String] Alphanumeric UUID of the message.
            attr_accessor :message_uuid

            # @!attribute [rw] number
            #   @return [String] Number to which the message was sent.
            attr_accessor :number

            # @!attribute [rw] tool
            #   @return [String] Tool used to send the message.
            attr_accessor :tool

            # @!attribute [rw] sender_id
            #   @return [String] Sender ID displayed on the recipient's device.
            attr_accessor :sender_id

            # @!attribute [rw] text
            #   @return [String] Text of the message.
            attr_accessor :text

            # @!attribute [rw] status
            #   @return [String] Delivery status of the message.
            attr_accessor :status

            # @!attribute [rw] status_time
            #   @return [Time] Time that the status was last updated. May be nil if the status
            #                  has never been updated.
            attr_accessor :status_time

            # @!attribute [rw] cost
            #   @return [String] Amount that it cost to send this message.
            attr_accessor :cost

            # Construct a new blank SMS details object.
            #
            def initialize
                @message_uuid = nil
                @number       = nil
                @tool         = nil
                @sender_id    = nil
                @text         = nil
                @status       = nil
                @status_time  = nil
                @cost         = nil
            end

            # Returns a hash representing the object.
            #
            # @return [Hash] Resulting hash.
            #
            def to_hash
                hash                = {}
                hash['MessageUUID'] = @message_uuid unless @message_uuid.nil?
                hash['Number']      = @number unless @number.nil?
                hash['Tool']        = @tool unless @tool.nil?
                hash['SenderId']    = @sender_id unless @sender_id.nil?
                hash['Text']        = @text unless @text.nil?
                hash['Status']      = @status unless @status.nil?
                hash['StatusTime']  = @status_time.to_i.to_s unless @status_time.nil?
                hash['Cost']        = @cost unless @cost.nil?
                hash
            end

            # Construct a new SMS details object from the provided arguments.
            #
            # @param [String] message_uuid Alphanumeric UUID of the message.
            # @param [String] number Number the message was sent to.
            # @param [String] tool Tool used to send the message.
            # @param [String] sender_id Sender ID information displayed to recipient.
            # @param [String] text Message text.
            # @param [String] status Delivery status of the message.
            # @param [Time] status_time Last time the status was updated.
            # @param [String] cost Amount that the message cost.
            #
            # @return [{SmsDetails}] New object.
            #
            # @raise [ArgumentError] An argument is missing or invalid.
            #
            def self.create(message_uuid, number, text, tool: nil, sender_id: nil, status: nil,
                status_time: nil, cost: nil)
                if message_uuid.nil? || !message_uuid.kind_of?(String) || message_uuid.empty?
                    raise ArgumentError, "Message UUID must be a non-empty string."
                end
                if number.nil? || !number.kind_of?(String) || number.empty?
                    raise ArgumentError, "Number must be a non-empty string."
                end
                if text.nil? || !text.kind_of?(String) || text.empty?
                    raise ArgumentError, "Message text must be a non-empty string."
                end
                if (!tool.nil? && !tool.kind_of?(String)) ||
                    (!sender_id.nil? && !sender_id.kind_of?(String)) ||
                    (!status.nil? && !status.kind_of?(String)) ||
                    (!status_time.nil? && !status_time.kind_of?(Time)) ||
                    (!cost.nil? && !cost.kind_of?(String))
                    raise ArgumentError, "Invalid argument type."
                end

                obj              = SmsDetails.new
                obj.message_uuid = message_uuid
                obj.number       = number
                obj.tool         = tool
                obj.sender_id    = sender_id
                obj.text         = text
                obj.status       = status
                obj.status_time  = status_time
                obj.cost         = cost
                obj
            end

            # Construct a new SMS details object from a hash returned by the API.
            #
            # @param [Hash] hash Hash from the response.
            #
            # @return [SmsDetails] New SMS details object.
            #
            def self.from_hash(hash)
                if hash.nil? || !hash.kind_of?(Hash)
                    raise ArgumentError, "Argument must be a hash."
                end
                obj = SmsDetails.new
                hash.each do |k, v|
                    case k
                    when 'MessageUUID' then
                        obj.message_uuid = CGI.unescape(v) unless v.nil?
                    when 'Number' then
                        obj.number = CGI.unescape(v) unless v.nil?
                    when 'Tool' then
                        obj.tool = CGI.unescape(v) unless v.nil?
                    when 'SenderId' then
                        obj.sender_id = CGI.unescape(v) unless v.nil?
                    when 'Text' then
                        obj.text = CGI.unescape(v) unless v.nil?
                    when 'Status' then
                        obj.status = CGI.unescape(v) unless v.nil?
                    when 'StatusTime' then
                        obj.status_time = Time.at(CGI.unescape(v).to_i) unless v.nil?
                    when 'Cost' then
                        obj.cost = CGI.unescape(v) unless v.nil?
                    end
                end
                obj
            end

        end

        # endregion SmsDetails class

        # Construct an SMS object to send messages using a specific endpoint.
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

        # Send an SMS message to a single number.
        #
        # @param [String] number (required) Number to send SMS to.
        # @param [String] body_text (required) Text for the body of the SMS message.
        # @param [String] sender_id Sender ID to use when sending.
        # @param [String] notify_url URL to be notified of message delivery.
        # @param [String] notify_http_method HTTP method to use for notification.
        #
        # @return [Array({StatusResponse}, String)]
        #   - Status of the operation.
        #   - UUID of the new message.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def send(number, body_text, sender_id: nil, notify_url: nil, notify_http_method: nil)
            if number.nil? || !number.kind_of?(String) || number.empty?
                raise ArgumentError, "Number must be supplied."
            end
            if body_text.nil? || !body_text.kind_of?(String) || body_text.empty?
                raise ArgumentError, "Body text of message must be supplied."
            end

            url     = @endpoint.url + SMS_PATH + '/'
            headers = @endpoint.headers

            values                       = { 'Number' => number, 'Text' => body_text }
            values['SenderId']           = sender_id unless sender_id.nil?
            values['DRNotifyUrl']        = notify_url unless notify_url.nil?
            values['DRNotifyHttpMethod'] = notify_http_method unless notify_http_method.nil?

            message_uuid = nil
            begin
                response = RestClient.post url, values.to_json, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    message_uuid   = result['MessageUUID']
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, message_uuid
        end

        # Send an SMS message to multiple numbers in a single operation.
        #
        # @param [Array<String>] number_list (required) List of numbers to send the message to.
        # @param [String] body_text (required) Text for the body of the SMS message.
        # @param [String] sender_id Sender ID to use when sending.
        # @param [String] notify_url URL to be notified of message delivery.
        # @param [String] notify_http_method HTTP method to use for notification.
        #
        # @return [Array({StatusResponse}, String, Array<String>)]
        #   - Status of the operation.
        #   - UUID of the message batch.
        #   - Array of message UUIDs.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def bulk_send(number_list, body_text, sender_id: nil, notify_url: nil, notify_http_method: nil)
            if number_list.nil? || !number_list.kind_of?(Array) || number_list.empty?
                raise ArgumentError, "List of numbers in an array must be supplied."
            end
            if body_text.nil? || !body_text.kind_of?(String) || body_text.empty?
                raise ArgumentError, "Body text of message must be supplied."
            end

            url     = @endpoint.url + BULK_SMS_PATH + '/'
            headers = @endpoint.headers

            values                       = { 'Numbers' => number_list, 'Text' => body_text }
            values['SenderId']           = sender_id unless sender_id.nil?
            values['DRNotifyUrl']        = notify_url unless notify_url.nil?
            values['DRNotifyHttpMethod'] = notify_http_method unless notify_http_method.nil?

            batch_uuid    = nil
            message_uuids = nil
            begin
                response = RestClient.post url, values.to_json, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    batch_uuid     = result['BatchUUID']
                    message_uuids  = result['MessageUUIDs']
                else
                    status = StatusResponse.new(false, "No response received.")
                end
            rescue StandardError => e
                status = StatusResponse.new(false, e.to_s)
            end
            return status, batch_uuid, message_uuids
        end

        # Retrieve the details of an SMS message by it's identifying UUID.
        #
        # @param [String] message_uuid (required) Identifying message UUID of the message.
        #
        # @return [Array({StatusResponse}, {SmsDetails})]
        #   - Status of the operation.
        #   - Details of the SMS message.
        #
        # @raise [ArgumentError] A required argument is missing or an argument is invalid.
        #
        def get_details(message_uuid)
            if message_uuid.nil? || !message_uuid.kind_of?(String) || message_uuid.empty?
                raise ArgumentError, "Message UUID must be a non-empty string."
            end

            url     = @endpoint.url + SMS_PATH + '/' + CGI.escape(message_uuid) + "/"
            headers = @endpoint.headers

            details = nil
            begin
                response = RestClient.get url, headers
                if !response.nil?
                    status, result = StatusResponse.from_response(response)
                    details_hash   = result['SMS']
                    if !details_hash.nil?
                        details = SmsDetails.from_hash(details_hash)
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

        # Retrieve a collection of messages, optionally filtering by time and/or sender ID.
        # A limit may be specified to limit the returned collection to only a given number of
        # messages, and an offset may be specified to start the returned collection to the given
        # position in the total collection found.
        #
        # @param [Time] from Date/time of the earliest message to retrieve. (default: beginning of day today)
        # @param [Time] to Date/time of the latest message to retrieve. (default: end of day today)
        # @param [String] sender_id Sender ID to retrieve messages for.
        # @param [Integer] offset Position to start returning messages from. (default: 0)
        # @param [Integer] limit Maximum number of messages to return in one call. (default: 10)
        #
        # @return [Array({StatusResponse}, {SmsDetails})]
        #   - Status of the operation.
        #   - Array of detail objects of the SMS messages matching the criteria.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def get_collection(from: nil, to: nil, sender_id: nil, offset: nil, limit: nil)
            if !from.nil? && !from.kind_of?(Time)
                raise ArgumentError, "From argument must be a time."
            end
            if !to.nil? && !to.kind_of?(Time)
                raise ArgumentError, "To argument must be a time."
            end
            if !sender_id.nil? && (!sender_id.kind_of?(String) || sender_id.empty?)
                raise ArgumentError, "Sender ID argument must be a non-empty string."
            end
            if !offset.nil? && !offset.kind_of?(Numeric)
                raise ArgumentError, "Offset argument must be a number."
            end
            if !limit.nil? && !limit.kind_of?(Numeric)
                raise ArgumentError, "Limit argument must be a number."
            end

            url          = @endpoint.url + SMS_PATH + '/'
            query_string = ''
            query_string += '&FromDate=' + CGI.escape(from.strftime('%Y-%m-%d %H:%M:%S')) unless from.nil?
            query_string += '&ToDate=' + CGI.escape(to.strftime('%Y-%m-%d %H:%M:%S')) unless to.nil?
            query_string += '&SenderId=' + CGI.escape(sender_id) unless sender_id.nil?
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
                    details_list   = result['SMSes']
                    if !details_list.nil?
                        returned_detail_list = []
                        details_list.each do |details_hash|
                            details = SmsDetails.from_hash(details_hash)
                            returned_detail_list.push details
                        end
                    else
                        status = StatusResponse.new(false, "No list of message details included in response.")
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
