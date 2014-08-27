module Cybersourcery
  class CartSignatureChecker < Cybersourcery::SignatureChecker
    attr_reader :session

    def post_initialize(args)
      @session = args[:session]
    end

    def signed_field_names
      @session[:signed_cart_fields]
    end

    def signature
      @session[:cart_signature]
    end
  end
end
