# SmsCountryApi

Ruby wrapper for the SMSCountry web service API.

## Installation

Installation of the gem must be done using the gemfile directly:

    gem install SmsCountryApi.gem

This gem depends on `rest-client` and `json`. When installing it you must
have those gems installed or be able to have those gems and their dependencies
installed automatically by the `gem` command.

For development you will need the development dependencies installed or able to
be installed automatically. The standard dependencies on `bundler`, `rake` and
`minitest` are needed as well as `yard` for documentation and `webmock` for testing.

Consult the gemspec for version requirements.

## Usage

The canonical return from an API call method is an array. The first element will always
be a `StatusResponse` object containing the operation's success/failure flag, a message
describing the results of the operation and an API ID (a UUID). Depending on the API call
there will be more elements containing results returned from the call. If the call failed,
those additional elements will be `nil`.

### SMS interface

#### Sending a single SMS message

    require 'SmsCountryApi'

    client = SmsCountryApi.create_client()
    status, data = client.sms.send("91XXXXXXXXXX", "Example message.", sender_id: "SMSCountry",
                                   notify_url: "https://www.domainname.com/notifyurl")
    if status.success
        message_uuid = data['MessageUUID']
    else
        message_uuid = nil
        log.error(status.message)
    end

*TODO*

### Call interface

*TODO*

### Group interface

*TODO*

### Group Call interface

*TODO*
