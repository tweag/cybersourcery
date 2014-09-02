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

helpers do
  def cybersource_proxy_uri
    "http://#{settings.bind}:#{settings.port}"
  end

  def hijack_uri(hijacker, victim)
    hijacker  = URI(hijacker)
    victim    = URI(victim)
    generic   = URI::Generic.build(
      scheme:   hijacker.scheme, userinfo: hijacker.userinfo,
      host:     hijacker.host,   port:     hijacker.port,
      path:     victim.path,     query:    victim.query,
      fragment: victim.fragment
    )
    URI(generic.to_s)
  end

  def hijack_body_uris(body)
    doc = Nokogiri::HTML(body)
    %w(src href action).each do |attribute|
      doc.xpath("//*[@#{attribute}]").each do |node|
        victim          = node[attribute]
        hijacker        = hijacker_for_uri(victim)
        node[attribute] = hijack_uri(hijacker, victim)
      end
    end
    doc.to_html
  end

  def hijacker_for_uri(victim)
    if URI(victim).absolute? && victim !~ /cybersource/i
      request.referrer
    else
      cybersource_proxy_uri
    end
  end

  def proxy_request
    cybersource_uri = hijack_uri(Cybersourcery.configuration.sop_test_url, uri)
    response = yield(cybersource_uri)
    code     = response.code.to_i
    type     = response.content_type
    body     = response.body
    body     = hijack_body_uris(body) if type =~ /html/
    response = code, { 'Content-Type' => type }, body
    response # Grrr. Rubocop.
  end
end
