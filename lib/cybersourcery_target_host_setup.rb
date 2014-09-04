require 'sinatra'
require 'base64'
require 'json'
require 'vcr'
require 'nokogiri'
require 'webmock'
require 'cybersourcery'
require File.expand_path File.dirname(__FILE__) + '/../spec/demo/config/initializers/cybersourcery.rb'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

def vcr_request_matcher_match?(pattern, body1, body2)
  if body1 =~ pattern && body2 =~ pattern
    one = pattern.match(body1).captures[0]
    two = pattern.match(body2).captures[0]
    one == two
  else
    body1 !~ pattern && body2 !~ pattern
  end
end
