Cybersourcery.configure do |config|
  config.profiles = "#{Rails.root}/config/cybersourcery_profiles.yml"
  config.mock_silent_order_post_url = 'http://localhost:4567'
end
