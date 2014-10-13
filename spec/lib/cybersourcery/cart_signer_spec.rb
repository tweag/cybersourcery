require 'rails_helper'

describe Cybersourcery::CartSigner do
  let(:transaction_url) do
    'https://testsecureacceptance.cybersource.com/silent/pay'
  end

  let(:session) do
    {}
  end

  let(:cart_fields) do
    { amount: '100' }
  end

  let(:cybersource_signer) do
    OpenStruct.new(
      signed_fields: {
        amount:             '100',
        signed_field_names: 'amount',
        signature:          'SUPER_SECURE_SIGNATURE'
      }
    )
  end

  subject(:cart_signer) do
    described_class.new(session, cybersource_signer, cart_fields.dup)
  end

  describe '#run' do
    before do
      cart_signer.run
    end

    it 'sets the signed fields' do
      expect(cart_signer.signed_cart_fields).to eq cart_fields
    end

    it 'reassigns the signature and signed_fields to the session' do
      expect(
        cart_signer.session[:signed_cart_fields]
      ).to eq cybersource_signer.signed_fields[:signed_field_names]

      expect(
        cart_signer.session[:cart_signature]
      ).to eq cybersource_signer.signed_fields[:signature]
    end
  end
end
