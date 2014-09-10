Cybersourcery.configure do |config|
  config.profiles = "#{Rails.root}/config/cybersourcery_profiles.yml"
  config.sop_live_url =  ENV['CYBERSOURCERY_SOP_LIVE_URL']
  config.sop_test_url = ENV['CYBERSOURCERY_SOP_TEST_URL']
  config.sop_proxy_url = ENV['CYBERSOURCERY_SOP_PROXY_URL']
end
