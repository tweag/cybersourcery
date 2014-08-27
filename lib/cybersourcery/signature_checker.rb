module Cybersourcery
  class SignatureChecker
    attr_reader :profile, :params

    def initialize(args = {})
      @profile = args[:profile]
      @params = args[:params]
      post_initialize(args)
    end

    # subclasses can override
    def post_initialize(args)
      nil
    end

    def run
      signature == Cybersourcery::CybersourceSigner::Signer.signature(signature_message, @profile.secret_key)
    end

    def run!
      raise Cybersourcery::CybersourceryError, 'Detected possible data tampering. Signatures do not match.' unless run
    end

    private

    def signed_field_names
      raise NotImplementedError, "This #{self.class} cannot respond to:"
    end

    def signature
      raise NotImplementedError, "This #{self.class} cannot respond to:"
    end

    def signature_message
      signed_fields_keys = signed_field_names.split(',')
      signed_fields = @params.select { |k, v| signed_fields_keys.include? k }
      Cybersourcery::CybersourceSigner.signature_message(signed_fields, signed_fields_keys)
    end
  end
end
