require 'cybersourcery_target_host_setup'

VCR.configure do |c|
  c.register_request_matcher :card_number_equality do |request_1, request_2|
    pattern = /\&card_number=(\d+)\&/i
    vcr_request_matcher_match?(pattern, request_1.body, request_2.body)
  end
end

get('/') { "It's not a trick it's an illusion" }

get '/*' do |path|
  proxy_request do |uri|
    Net::HTTP.get_response(uri)
  end
end

post '/*' do |path|
  proxy_request do |uri|
    if Cybersourcery.configuration.use_vcr_in_tests
      VCR.use_cassette('cybersourcery',
        record: :new_episodes,
        match_requests_on: %i(method uri card_number_equality)) do
        Net::HTTP.post_form(uri, params)
      end
    else
      Net::HTTP.post_form(uri, params)
    end
  end
end
