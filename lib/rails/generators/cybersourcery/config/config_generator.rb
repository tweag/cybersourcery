module Cybersourcery
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      desc 'Creates a configuration file and an initializer file for the Cybersourcery gem'

      def self.source_root
        @source_root ||= File.expand_path('../templates', __FILE__)
      end

      def create_config_file
        template 'cybersourcery_profiles.yml', File.join('config', 'cybersourcery_profiles.yml')
      end

      def create_initializer_file
        template 'cybersourcery.rb', File.join('config', 'initializers', 'cybersourcery.rb')
      end
    end
  end
end
