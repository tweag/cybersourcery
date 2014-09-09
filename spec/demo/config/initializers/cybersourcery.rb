Cybersourcery.configure do |config|
  # this file is also read by the proxy running on Sinatra, so don't depend on Rails.root
  rails_root = File.expand_path File.dirname(__FILE__) + '/../..'
  config.profiles = "#{rails_root}/config/cybersourcery_profiles.yml"
  config.sop_live_url =  ENV['CYBERSOURCERY_SOP_LIVE_URL']
  config.sop_test_url = ENV['CYBERSOURCERY_SOP_TEST_URL']
  config.sop_proxy_url = ENV['CYBERSOURCERY_SOP_PROXY_URL']
  config.use_vcr_in_tests = ENV['CYBERSOURCERY_USE_VCR_IN_TESTS']
end
