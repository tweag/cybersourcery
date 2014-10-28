module Cybersourcery
  class Container
    def self.get_cart_signer(profile_name, session, cart_fields)
      profile = get_profile(profile_name)
      cybersource_signer = Cybersourcery::CybersourceSigner.new(profile)
      Cybersourcery::CartSigner.new(session, cybersource_signer, cart_fields)
    end

    def self.get_cart_signature_checker(profile_name, params, session)
      profile = get_profile(profile_name)
      Cybersourcery::CartSignatureChecker.new({ profile: profile, params: params, session: session})
    end

    def self.get_cybersource_signature_checker(profile_name, params)
      profile = get_profile(profile_name)
      Cybersourcery::CybersourceSignatureChecker.new({ profile: profile, params: params })
    end

    def self.get_payment(profile_name, params, payment_class_name = 'Payment')
      profile = get_profile(profile_name)
      signer = Cybersourcery::CybersourceSigner.new(profile)
      payment_class_name.constantize.new(signer, profile, params)
    end

    def self.get_profile(profile_id, profiles = Cybersourcery.configuration.profiles)
      Cybersourcery::Profile.new(profiles[profile_id].merge(profile_id: profile_id))
    end
  end
end
