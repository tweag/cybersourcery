require 'rails_helper'

describe Cybersourcery::Profile do
  let(:unsigned_field_names) do
    %w(
      bill_to_email
      bill_to_forename
      bill_to_surname
      bill_to_address_line1
      bill_to_address_line2
      bill_to_address_country
      bill_to_address_state
      bill_to_address_postal_code
      bill_to_address_city
      card_cvn
      card_expiry_date
      card_number
      card_type
    )
  end

  let(:profiles) do
    { 'pwksgem' =>
      {
        'name' => 'PromptWorks Gem',
        'service' => 'test',
        'access_key' => '839d4d3b1cef3e04bd2981997714803b',
        'secret_key' => 'really-long-secret-key',
        'success_url' => 'http://tranquil-ocean-5865.herokuapp.com/responses',
        'transaction_type' => 'sale',
        'endpoint_type' => 'standard',
        'payment_method' => 'card',
        'locale' => 'en-us',
        'currency' => 'USD',
        'unsigned_field_names' => unsigned_field_names
      }
    }
  end

  describe '#initialize' do
    it 'sets the attributes when they are valid' do
      profile = described_class.new('pwksgem', profiles)
      expect(profile.profile_id).to eq 'pwksgem'
      expect(profile.name).to eq 'PromptWorks Gem'
      expect(profile.service).to eq 'test'
      expect(profile.access_key).to eq '839d4d3b1cef3e04bd2981997714803b'
      expect(profile.secret_key).to eq 'really-long-secret-key'
      expect(profile.transaction_type).to eq 'sale'
      expect(profile.endpoint_type).to eq :standard
      expect(profile.payment_method).to eq 'card'
      expect(profile.locale).to eq 'en-us'
      expect(profile.currency).to eq 'USD'
      expect(profile.unsigned_field_names).to eq unsigned_field_names
      expect(
        profile.success_url
      ).to eq 'http://tranquil-ocean-5865.herokuapp.com/responses'
    end

    it 'raises an exception if the "service" value is not "live" or "test"' do
      profiles['pwksgem']['service'] = 'foo'

      expect do
        described_class.new('pwksgem', profiles)
      end.to raise_exception(Cybersourcery::CybersourceryError)
    end

    it 'raises an exception if the "endpoint_type" is not valid' do
      profiles['pwksgem']['endpoint_type'] = 'foo'

      expect do
        described_class.new('pwksgem', profiles)
      end.to raise_exception(Cybersourcery::CybersourceryError)
    end

    it 'raises an exception if any setting is missing' do
      profiles['pwksgem']['access_key'] = nil

      expect do
        described_class.new('pwksgem', profiles)
      end.to raise_exception(Cybersourcery::CybersourceryError)
    end
  end

  # The arguments to transaction_url are normally not needed, as they are
  # determined from the environment. The arguments are to facilitate testing
  # only.
  describe '#transaction_url' do
    it 'returns the proxy URL, if in test env and proxy URL is defined' do
      profile = described_class.new('pwksgem', profiles)
      transaction_url = profile.transaction_url('http://localhost:5556')
      expect(transaction_url).to eq 'http://localhost:5556/silent/pay'
    end

    it 'returns "test" service URL, if in test env and proxy URL not defined' do
      profiles['pwksgem']['service'] = 'test'
      profile = described_class.new('pwksgem', profiles)
      transaction_url = profile.transaction_url(nil)
      expect(
        transaction_url
      ).to eq 'https://testsecureacceptance.cybersource.com/silent/pay'
    end

    it 'returns "test" service URL, if not in test env and using test server' do
      profiles['pwksgem']['service'] = 'test'
      profile = described_class.new('pwksgem', profiles)
      transaction_url = profile.transaction_url(nil, 'development')
      expect(
        transaction_url
      ).to eq 'https://testsecureacceptance.cybersource.com/silent/pay'
    end

    it 'returns "live" service URL, if not in test env and using live server' do
      profiles['pwksgem']['service'] = 'live'
      profile = described_class.new('pwksgem', profiles)
      transaction_url = profile.transaction_url(nil, 'development')
      expect(
        transaction_url
      ).to eq 'https://secureacceptance.cybersource.com/silent/pay'
    end
  end
end
