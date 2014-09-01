module Cybersourcery
  class Configuration
    attr_reader :profiles
    attr_accessor :sop_proxy_url

    def profiles=(profiles_path)
      @profiles = YAML.load_file profiles_path
    end
  end
end
