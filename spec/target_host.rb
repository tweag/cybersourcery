require 'sinatra'
require 'base64'
require 'json'

get('/') { "It's not a trick it's an illusion" }

# post '/off/*' do |path|
#   proxy_request do |uri|
#     Net::HTTP.post_form(uri, params)
#   end
# end
#
# get '/*' do |path|
#   proxy_request do |uri|
#     Net::HTTP.get_response(uri)
#   end
# end
#
# post '/*' do |path|
#   proxy_request do |uri|
#     if ENV['CYBERSOURCE_REPLAY'] == "true"
#       VCR.use_cassette("SORCERY",
#         record: :new_episodes,
#         match_requests_on: %i(method uri card_number_equality)) do
#         Net::HTTP.post_form(uri, params)
#       end
#     end
#   end
# end
