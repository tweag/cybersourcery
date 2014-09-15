module Cybersourcery
  class Configuration
    attr_accessor :profiles_path

    def profiles
      @profiles ||= YAML.load_file profiles_path
    end
  end
end
