module Cybersourcery
  class Configuration
    attr_reader :profiles

    def profiles=(profiles_path)
      @profiles = YAML.load_file profiles_path
    end
  end
end
