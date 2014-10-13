require 'rails_helper'

describe Cybersourcery::Payment do
  let(:transaction_url) do
    'https://testsecureacceptance.cybersource.com/silent/pay'
  end

  let(:profile) { double :profile, transaction_url: transaction_url }
  let(:cybersource_signer) do
    double(
      :cybersource_signer,
      add_and_sign_fields: {
        payment_method: 'card',
        locale:         'en',
        signature:      'SUPER_SECURE_SIGNATURE'
      }
    )
  end

  subject(:payment) { described_class.new(cybersource_signer, profile, {}) }

  # doing minimal testing of validation here, as feature specs cover this
  describe '#initialize' do
    it 'fails validation when required params are not set' do
      expect(payment.valid?).to be_falsey
    end
  end

  describe '#form_action_url' do
    it 'returns the form action url' do
      expect(payment.form_action_url).to eq transaction_url
    end
  end

  describe '#sign_cybersource_fields' do
    it 'returns the signed cybersource fields' do
      expect(payment.signed_fields).to eq cybersource_signer.add_and_sign_fields
    end
  end
end
