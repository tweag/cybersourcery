module Cybersourcery
  class Configuration
    attr_reader :profiles
    attr_accessor :mock_silent_order_post_url

    def profiles=(profiles_path)
      @profiles = YAML.load_file profiles_path
    end
  end
end
