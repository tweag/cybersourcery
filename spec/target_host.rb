require 'sinatra'
require 'base64'
require 'json'
require 'vcr'
require 'nokogiri'
require 'webmock'

VCR.configure do |c|
  c.cassette_library_dir = 'cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
  c.register_request_matcher :card_number_equality do |request_1, request_2|
    pattern = /\&card_number=(\d+)\&/i
    body1   = request_1.body
    body2   = request_2.body
    if body1 =~ pattern && body2 =~ pattern
      one = pattern.match(body1).captures[0]
      two = pattern.match(body2).captures[0]
      one == two
    else
      body1 !~ pattern && body2 !~ pattern
    end
  end
end

helpers do
  # TODO: delete this?
  def logger
    request.logger
  end

  def sorcery_uri
    "http://#{settings.bind}:#{settings.port}"
  end

  def hijack_uri(hijacker, victim)
    victim = victim.gsub("off/", "")
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

  def hijack_body_uris(request, body)
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
      sorcery_uri
    end
  end

  def proxy_request
    puts 'WE ARE HERE 1 ********'
    #cybersource_uri = hijack_uri(ENV['CYBERSOURCE_HOST'], uri)
    cybersource_uri = hijack_uri('https://testsecureacceptance.cybersource.com', uri)
    response = yield(cybersource_uri)
    code     = response.code.to_i
    type     = response.content_type
    body     = response.body
    body     = hijack_body_uris(request, body) if type =~ /html/
    response = code, { 'Content-Type' => type }, body
    response # Grrr. Rubocop.
  end
end

get('/') { "It's not a trick it's an illusion" }

post '/off/*' do |path|
  proxy_request do |uri|
    Net::HTTP.post_form(uri, params)
  end
end

get '/*' do |path|
  proxy_request do |uri|
    Net::HTTP.get_response(uri)
  end
end

post '/*' do |path|
  proxy_request do |uri|
    #if ENV['CYBERSOURCE_REPLAY'] == "true"
      VCR.use_cassette("SORCERY",
        record: :new_episodes,
        match_requests_on: %i(method uri card_number_equality)) do
        Net::HTTP.post_form(uri, params)
      end
    #end
  end
end
