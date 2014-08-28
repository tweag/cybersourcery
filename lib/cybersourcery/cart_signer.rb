module Cybersourcery
  class CartSigner
    attr_reader :session, :signer, :cart_fields, :signed_cart_fields

    def initialize(session, signer, cart_fields)
      @session = session
      @signer = signer
      @cart_fields = cart_fields
    end

    def run
      sign_cart_fields
      reassign_signature_and_signed_fields_to_session
      @signed_cart_fields
    end

    private

    def sign_cart_fields
      @cart_fields[:signed_field_names] = @cart_fields.keys.join(',')
      @signer.form_fields = cart_fields
      @signed_cart_fields = @signer.signed_fields.dup
    end

    def reassign_signature_and_signed_fields_to_session
      @session[:signed_cart_fields] = @signed_cart_fields.delete :signed_field_names
      @session[:cart_signature] = @signed_cart_fields.delete :signature
      @session
    end
  end
end
