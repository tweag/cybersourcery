Cybersourcery.configure do |config|
  config.profiles_path = "#{Rails.root}/config/cybersourcery_profiles.yml"
  config.sop_live_url =  'https://secureacceptance.cybersource.com'
  config.sop_test_url = 'https://testsecureacceptance.cybersource.com'
end
