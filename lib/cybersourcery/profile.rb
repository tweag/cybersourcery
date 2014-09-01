require 'active_support'
require 'active_support/core_ext/array/conversions.rb' # so we can use to_sentence

module Cybersourcery
  class Profile
    include ActiveModel::Validations

    VALID_ENDPOINTS = {
      standard: '/silent/pay',
      create_payment_token: '/silent/token/create',
      update_payment_token: '/silent/token/update',
      iframe_standard: '/silent/embedded/pay',
      iframe_create_payment_token: 'silent/embedded/token/create',
      iframe_update_payment_token: '/silent/embedded/token/update'
    }

    attr_accessor :profile_id, :name, :service, :access_key, :secret_key, :success_url,
                  :transaction_type, :endpoint_type, :payment_method, :locale, :currency
    validates_presence_of :profile_id, :name, :service, :access_key, :secret_key
    validates_inclusion_of :service, in: %w(test live), allow_nil: false
    validates_inclusion_of :endpoint_type, in: VALID_ENDPOINTS.keys, allow_nil: false
    validates_inclusion_of :payment_method, in: %w(card echeck), allow_nil: false
    validates_format_of :locale, with: /\A[a-z]{2}-[a-z]{2}\Z/, allow_nil: false
    validates_format_of :currency, with: /\A[A-Z]{3}\Z/, allow_nil: false

    def initialize(profile_id, profiles = Cybersourcery.configuration.profiles)
      profiles[profile_id].each do |k,v|
        self.send "#{k}=", v
      end

      @profile_id = profile_id
      @endpoint_type = @endpoint_type.to_sym

      unless self.valid?
        raise Cybersourcery::CybersourceryError, self.errors.full_messages.to_sentence
      end
    end

    def transaction_url
      if @service == 'live'
        "https://secureacceptance.cybersource.com#{VALID_ENDPOINTS[@endpoint_type]}"
      elsif @service == 'test'
        "https://testsecureacceptance.cybersource.com#{VALID_ENDPOINTS[@endpoint_type]}"
      else
        raise Cybersourcery::CybersourceryError, 'Invalid conditions for determining the transaction_url'
      end
    end
  end
end
