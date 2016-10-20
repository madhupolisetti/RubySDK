# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'SmsCountryApi/version'

Gem::Specification.new do |spec|
    spec.name    = 'SmsCountryApi'
    spec.version = SmsCountryApi::VERSION
    spec.date    = Time.now.strftime('%Y-%m-%d')
    spec.authors = ['Todd Knarr']
    spec.email   = ['tknarr@silverglass.org']

    spec.summary = %q{Wrapper for the SMSCountry API.}

    spec.require_paths    = ['lib']
    spec.files            = Dir.glob('lib/**/*.rb') + [__FILE__]
    spec.test_files       = Dir.glob('test/**/*.rb') + %w(Rakefile .travis.yml)
    spec.extra_rdoc_files = %w(README.md LICENSE.md .yardopts)

    spec.add_dependency 'rest-client', '~> 2.0'
    spec.add_dependency 'json', '~> 2.0'
    spec.add_dependency 'addressable', '~> 2.4'

    spec.add_development_dependency 'bundler', '~> 1.13'
    spec.add_development_dependency 'rake', '~> 10.0'
    spec.add_development_dependency 'minitest', '~> 5.0'
    spec.add_development_dependency 'yard', '~> 0.9'
    spec.add_development_dependency 'webmock', '~> 2.0'
end
