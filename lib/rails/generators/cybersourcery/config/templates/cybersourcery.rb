Cybersourcery.configure do |config|
  config.profiles = "#{Rails.root}/config/cybersourcery_profiles.yml"
  config.sop_live_url = 'https://secureacceptance.cybersource.com'
  config.sop_test_url = 'https://testsecureacceptance.cybersource.com'
  config.sop_proxy_url = 'http://localhost:5555'
  config.use_vcr_in_tests = true
end
