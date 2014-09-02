module Cybersourcery
  class Container
    def self.get_cart_signer(profile_name, session, cart_fields)
      profile = Cybersourcery::Profile.new(profile_name)
      cybersource_signer = Cybersourcery::CybersourceSigner.new(profile)
      Cybersourcery::CartSigner.new(session, cybersource_signer, cart_fields)
    end
  end
end
