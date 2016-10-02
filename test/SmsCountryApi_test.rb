#-----
#
# SmsCountryApi
# Copyright (C) 2016 Todd Knarr
#
#-----

require './test_helper'

class SmsCountryApiTest < Minitest::Test

    def test_that_it_has_a_version_number
        refute_nil ::SmsCountryApi::VERSION
    end

end
