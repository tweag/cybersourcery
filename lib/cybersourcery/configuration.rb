module Cybersourcery
  class Configuration
    attr_reader :profiles
    attr_accessor :sop_proxy_url, :sop_live_url, :sop_test_url, :use_vcr_in_tests

    def profiles=(profiles_path)
      @profiles = YAML.load_file profiles_path
    end
  end
end
