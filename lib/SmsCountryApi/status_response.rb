#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require 'json'

module SmsCountryApi

    # Encapsulate the standard response information: API UUID, success flag, descriptive message.
    #
    # All operations return a list whose first object will be a {StatusResponse} object that can
    # be checked for success or failure. The list may contain additional objects depending on
    # what the operation needs to return.
    #
    class StatusResponse

        # @!attribute [r] api_uuid
        #   @return [String] API UUID.
        attr_reader :api_uuid

        # @!attribute [r] success
        #   @return [Boolean] `true` if the operation succeeded, `false` if it failed.
        attr_reader :success

        # @!attribute [r] message
        #   @return [String] Message describing the result of the operation.
        attr_reader :message

        # Construct a new response status object.
        #
        # @param [Boolean] success Success/Failure flag.
        # @param [String] message Message describing the operation's result.
        # @param [String] uuid API UUID.
        #
        # @raise [ArgumentError] An argument is invalid.
        #
        def initialize(success, message = nil, uuid: nil)
            @success = success ? true : false
            if message.nil? || message.kind_of?(String)
                @message = message
            else
                raise ArgumentError, "Message must be a string or nil."
            end
            if uuid.nil? || uuid.kind_of?(String)
                @api_uuid = uuid
            else
                raise ArgumentError, "Invalid UUID."
            end
        end

        # Generate a status object from the contents of an API results hash.
        #
        # @param [Hash] hash Results hash from the SMSCountry API.
        #
        # @return [StatusResponse] New status response object. The original hash will be modified to remove
        #                          the items now carried in the StatusResponse object.
        #
        def self.from_hash(hash)
            unless hash.kind_of?(Hash)
                return StatusResponse.new(false, "StatusResponse#from_hash did not get a hash.")
            end
            begin
                status = StatusResponse.new(hash['Success'], CGI.unescape(hash['Message'].to_s), uuid: hash['ApiId'].to_s)
                hash.delete_if { |k, _| k == 'Success' || k == 'Message' || k == 'ApiId' }
            rescue ArgumentError => e
                status = StatusResponse.new(false, "Problem extracting status: " + e.to_s)
            end
            return status
        end

        # Generate a status response object and results hash from an API call response.
        #
        # @param [RestClient::Response] response RestClient response object.
        #
        # @return [Array<(StatusResponse, Hash)>]
        #   - The new status response object.
        #   - Response hash from the API call minus the status-related items.
        #
        def self.from_response(response)
            if response.code / 100 == 2
                begin
                    result = JSON.parse(response.body)
                rescue StandardError
                    result = nil
                end
                if result.kind_of?(Hash)
                    status = self.from_hash(result)
                else
                    result = {}
                    status = StatusResponse.new(false, "Unparseable response: " + response.body)
                end
            else
                result = {}
                status = StatusResponse.new(false, "HTTP code " + response.code.to_s + ": " + response.body)
            end
            return status, result
        end

    end

end
