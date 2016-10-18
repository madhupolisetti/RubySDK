#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require 'base64'

module SmsCountryApi

    # Default hostname for the service.
    DEFAULT_HOST = 'restapi.smscountry.com'

    # Default path prefix for the service.
    DEFAULT_PATH = 'v0.1/Accounts'

    # Simple encapsulation of and endpoint URL and the required authentication parameters.
    class Endpoint
        # @!attribute [rw] key
        #   @return [String] API authentication key.
        attr_accessor :key

        # @!attribute [rw] token
        #   @return [String] API authentication token.
        attr_accessor :token

        # Construct an authentication object for the given key and token.
        #
        # @param [String] key (required) Authentication key.
        # @param [String] token (required) Authentication token. A nil value may be used to suppress the
        #                       normal basic authorization header completely if necessary for a mock server.
        # @param [Boolean] use_ssl `true` to use HTTPS, `false` to use plain HTTP. (default: true)
        # @param [String] host Name of host to use for the service URL. (default: service default)
        # @param [String] path Path prefix to use for the service URL. (default: service default)
        #
        # @raise [ArgumentError] One or more arguments are not valid.
        #
        def initialize(key, token, use_ssl: true, host: nil, path: nil)
            if key.nil? || !key.kind_of?(String) || key.empty? ||
                (!token.nil? && (!token.kind_of?(String) || token.empty?))
                raise ArgumentError, "Authentication key and token strings are not valid."
            end
            @key   = key
            @token = token

            @protocol = use_ssl ? 'https' : 'http'
            if host.nil?
                @host = DEFAULT_HOST
            elsif host.kind_of?(String) && !host.empty?
                @host = host
            else
                raise ArgumentError, "Hostname must be a non-empty string."
            end
            if path.nil?
                @path_prefix = DEFAULT_PATH
            elsif path.kind_of?(String)
                # Strip leading and trailing whitespace and leading and trailing slashes from the path, leave
                # whitespace after the leading slashes or before the trailing slashes.
                @path_prefix = path.sub(/\A\s*\/*/, '').sub(/\/*\s*\Z/, '')
            else
                raise ArgumentError, "Path must be a non-empty string."
            end
            @service_url = nil
        end

        # Construct the initial portion of the URL needed for service calls. This will
        # end with a slash ('/') and is suitable for appending a relative path to it for
        # a particular service call.
        #
        # @return [String] Service URL.
        #
        def url
            if @service_url.nil?
                @service_url = @protocol + '://' + @host + '/' +
                    (@path_prefix.empty? ? '' : (@path_prefix + '/')) + @key + '/'
            end
            @service_url
        end

        # Convert the object to a string suitable for use in the Authorization header.
        #
        # @return [String] Base64-encoded authorization header value.
        #
        def authorization
            @token.nil? ? nil : Base64.encode64(@key + ':' + @token).strip
        end

        # Standard endpoint headers.
        #
        # @return [Hash] Hash of standard headers for the endpoint.
        #
        def headers
            hash                 = { content_type: :json, accept: :json }
            unless self.authorization.nil?
                hash[:authorization] = 'Basic ' + self.authorization
            end
            hash
        end


    end

end
