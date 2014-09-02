Cybersourcery.configure do |config|
  # this file is also read by the proxy running on Sinatra, so don't depend on Rails.root
  rails_root = File.expand_path File.dirname(__FILE__) + '/../..'
  config.profiles = "#{rails_root}/config/cybersourcery_profiles.yml"
  config.sop_live_url = 'https://secureacceptance.cybersource.com'
  config.sop_test_url = 'https://testsecureacceptance.cybersource.com'
  config.sop_proxy_url = 'http://localhost:5555'
  config.use_vcr_in_tests = true
end
