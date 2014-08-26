require 'cybersourcery/version'
require 'cybersourcery/configuration'
require 'cybersourcery/exceptions'
require 'cybersourcery/merchant_data_serializer'

module Cybersourcery
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
