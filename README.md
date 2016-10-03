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

## SMSCountry API documentation

The documentation on the SMSCountry web service API is available at
[http://docs.smscountryapi.apiary.io/](http://docs.smscountryapi.apiary.io/).

## Usage

The canonical return from an API call method is an array. The first element will always
be a `StatusResponse` object containing the operation's success/failure flag, a message
describing the results of the operation and an API ID (a UUID). Depending on the API call
there will be more elements containing results returned from the call. If the call failed,
those additional elements will be `nil`. The various methods all insure that their return
value contains the proper number of elements so you can use Ruby array unwrapping safely.
For methods that only return the status object, the Ruby idiom of appending a comma to a
single variable can be used. Thus:

    status, = client.call.terminate_call(call_uuid)

would get the status from a terminate-call operation which returns just the status object.

### SMS interface

#### Sending a single SMS message

    require 'SmsCountryApi'

    client = SmsCountryApi.create_client()
    status, message_uuid = client.sms.send("91XXXXXXXXXX", "Example message.", sender_id: "SMSCountry",
                                           notify_url: "https://www.domainname.com/notifyurl")
    unless status.success
        message_uuid = nil
        log.error(status.message)
    end

The return value from the call is an array containing a status object and a string containing the
UUID of the message sent. If the operation failed, the error is logged and handled by the check
following the method call.

*TODO*

### Call interface

*TODO*

### Group interface

*TODO*

### Group Call interface

*TODO*
