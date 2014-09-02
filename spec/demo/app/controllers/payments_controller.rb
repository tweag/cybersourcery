class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :confirm
  before_action :normalize_cybersource_params, only: :confirm

  def pay
    setup_payment_form
  end

  # This receives a POST from the hidden form dynamically rendered in the user's browser by
  # Cybersource.
  def confirm
    signature_checker = Cybersourcery::Container.get_cybersource_signature_checker('pwksgem', params)
    signature_checker.run!

    flash.now[:notice] = Cybersourcery::ReasonCodeChecker::run!(params[:reason_code])

    serializer = Cybersourcery::MerchantDataSerializer.new
    @merchant_data = serializer.deserialize(params)
    #redirect_to profile.success_url # this is optional
  rescue Cybersourcery::CybersourceryError => e
    flash.now[:alert] = e.message
    # if there was an exception in setup_payment_form, it will have already rendered :error
    render :pay if setup_payment_form
  end

  private

  def normalize_cybersource_params
    params.keys.each do |key|
      params[key[4..-1]] = params[key] if key =~ /^req_/
    end
  end

  def setup_payment_form
    signature_checker = Cybersourcery::Container.get_cart_signature_checker('pwksgem', params, session)
    signature_checker.run!
    @payment = Cybersourcery::Container.get_payment('pwksgem', params, 'MyPayment')
    true
  rescue Cybersourcery::CybersourceryError => e
    # if there was an exception in confirm(), there will already be a flash message
    flash.now[:alert].present? ? flash.now[:alert] << " #{e.message}" : e.message
    render :error
    false
  end
end
