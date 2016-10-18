#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

module SmsCountryApi

    # Client object containing all objects needed to fully use the SMSCountry API.
    class Client

        # @!attribute [r] sms
        #   @return [SMS] SMS object for accessing the SMS API.
        attr_reader :sms

        # @!attribute [r] call
        #   @return [Call] Call object for accessing the Call API.
        attr_reader :call

        # @!attribute [r] group
        #   @return [Group] Group object for accessing the Group API.
        attr_reader :group

        # @!attribute [r] group_call
        #   @return [GroupCall] GroupCall object for accessing the GroupCall API.
        attr_reader :group_call

        # Construct a client object which will communicate with a service endpoint.
        #
        # @param [{Endpoint}] endpoint Endpoint the client will communicate with.
        #
        # @raise [ArgumentError] One or more arguments are not valid.
        #
        def initialize(endpoint)
            if endpoint.nil?
                raise ArgumentError, "Endpoint argument was not provided."
            elsif !endpoint.kind_of?(Endpoint)
                raise ArgumentError, "Endpoint argument is not an endpoint object."
            end

            @endpoint   = endpoint
            @sms        = SMS.new(@endpoint)
            @call       = Call.new(@endpoint)
            @group      = Group.new(@endpoint)
            @group_call = GroupCall.new(@endpoint)
        end

    end

    # Create a new client based on the application's configuration information.
    #
    # @return [Client] Client object configured for the application default service endpoint.
    #
    # @raise [ArgumentError] One or more arguments are not valid.
    # @raise [NotImplementedError] This function hasn't been implemented yet.
    #
    def self.create_client_from_config
        # TODO create the endpoint from application configuration data
        raise NotImplementedError, "#create_client_from_config is not implemented yet."
    end

    # Create a new client based on the arguments. The authentication information and
    # service endpoint URL components are provided in arguments. By default a client
    # using the default production service endpoint is created.
    #
    # @param [String] key (required) Authentication key.
    # @param [String] token (required) Authentication token.
    # @param [String] protocol 'http' or 'https'. (default: 'https')
    # @param [String] host Name of host to use for the service URL. (default: service default)
    # @param [String] path Path prefix to use for the service URL. (default: service default)
    #
    # @return [Client] Client object configured for the given service endpoint.
    #
    # @raise [ArgumentError] One or more arguments are not valid.
    #
    def self.create_client(key, token, protocol: 'http', host: nil, path: nil)
        if key.nil? || !key.kind_of?(String) || key.empty? ||
            token.nil? || !token.kind_of?(String) || token.empty?
            raise ArgumentError, "Key and token must be non-empty strings."
        end
        if protocol.nil? || !protocol.kind_of?(String) || protocol.empty?
            raise ArgumentError, "Protocol must be a non-empty string."
        else
            proto = protocol.downcase
            if proto != 'http' && proto != 'https'
                raise ArgumentError, "Unrecognized protocol " + protocol
            end
        end
        unless host.nil?
            if !host.kind_of?(String) || host.empty?
                raise ArgumentError, "Hostname must be a non-empty string."
            end
        end
        unless path.nil?
            unless path.kind_of?(String)
                raise ArgumentError, "Path must be a string."
            end
        end

        endpoint = Endpoint.new(key, token, use_ssl: (proto == 'https'), host: host, path: path)
        Client.new(endpoint)
    end

end
