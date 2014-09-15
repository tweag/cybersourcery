require 'cybersourcery_testing/cybersource_proxy'

VCR.configure do |c|
  c.register_request_matcher :card_type_equality do |request_1, request_2|
    pattern = /\&card_type=(\d+)\&/i
    CybersourceryTesting::Vcr.did_it_change?(pattern, request_1.body, request_2.body)
  end
end
