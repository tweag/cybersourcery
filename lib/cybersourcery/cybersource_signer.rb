require 'hmac-sha2'
require 'base64'

module Cybersourcery
  class CybersourceSigner
    attr_accessor :profile, :signer
    attr_writer   :time
    attr_writer   :form_fields
    attr_reader   :signable_fields

    IGNORE_FIELDS = %i[
      commit
      utf8
      authenticity_token
      action
      controller
    ]

    def initialize(profile, signer = Signer)
      @profile              = profile
      @signer               = signer
      @signable_fields      = {
        access_key:           @profile.access_key,
        profile_id:           @profile.profile_id,
        payment_method:       @profile.payment_method,
        locale:               @profile.locale,
        transaction_type:     @profile.transaction_type,
        currency:             @profile.currency
      }
    end

    def add_and_sign_fields(params)
      add_signable_fields(params)
      signed_fields
    end

    def add_signable_fields(params)
      @signable_fields.merge! params.symbolize_keys.delete_if { |k,v|
        @profile.unsigned_field_names.include?(k) || IGNORE_FIELDS.include?(k)
      }
    end

    def signed_fields
      form_fields.tap do |data|
        signature_keys = data[:signed_field_names].split(',').map(&:to_sym)
        signature_message = self.class.signature_message(data, signature_keys)
        data[:signature]  = signer.signature(signature_message, profile.secret_key)
      end
    end

    def form_fields
      @form_fields ||= signable_fields.dup.merge(
        unsigned_field_names: @profile.unsigned_field_names.join(','),
        transaction_uuid:     SecureRandom.hex(16),
        reference_number:     SecureRandom.hex(16),
        signed_date_time:     time,
        signed_field_names:   nil # make sure it's in data.keys
      ).tap do |data|
        data[:signed_field_names] = data.keys.join(',')
      end
    end

    def time
      @time ||= Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    end

    def self.signature_message(hash, keys)
      keys.map {|key| "#{key}=#{hash.fetch(key)}" }.join(',')
    end

    class Signer
      def self.signature(message, secret_key)
        mac = HMAC::SHA256.new(secret_key)
        mac.update message
        Base64.strict_encode64(mac.digest)
      end
    end
  end
end
