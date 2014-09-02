module Cybersourcery
  class Container
    def self.get_cart_signer(profile_name, session, cart_fields)
      profile = Cybersourcery::Profile.new(profile_name)
      cybersource_signer = Cybersourcery::CybersourceSigner.new(profile)
      Cybersourcery::CartSigner.new(session, cybersource_signer, cart_fields)
    end

    def self.get_cart_signature_checker(profile_name, params, session)
      profile = Cybersourcery::Profile.new(profile_name)
      Cybersourcery::CartSignatureChecker.new({ profile: profile, params: params, session: session})
    end

    def self.get_cybersource_signature_checker(profile_name, params)
      profile = Cybersourcery::Profile.new(profile_name)
      Cybersourcery::CybersourceSignatureChecker.new({ profile: profile, params: params })
    end

    def self.get_payment(profile_name, params, payment_class_name = 'Payment')
      profile = Cybersourcery::Profile.new(profile_name)
      signer = Cybersourcery::CybersourceSigner.new(profile)
      payment_class_name.constantize.new(signer, profile, params)
    end
  end
end
