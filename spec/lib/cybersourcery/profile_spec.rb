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

  def build_profile(attrs = {})
    described_class.new({
      profile_id:           'pwksgem',
      name:                 'PromptWorks Gem',
      service:              'test',
      access_key:           '839d4d3b1cef3e04bd2981997714803b',
      secret_key:           'really-long-secret-key',
      success_url:          'http://example.com/responses',
      transaction_type:     'sale',
      endpoint_type:        'standard',
      payment_method:       'card',
      locale:               'en-us',
      currency:             'USD',
      unsigned_field_names: unsigned_field_names
    }.merge(attrs))
  end

  describe '.get' do
    it 'sets the attributes when they are valid' do
      profile = build_profile
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
      ).to eq 'http://example.com/responses'
    end

    it 'raises an exception if the "service" value is not "live" or "test"' do
      expect { build_profile(service: 'foo') }
        .to raise_exception Cybersourcery::CybersourceryError
    end

    it 'raises an exception if the "endpoint_type" is not valid' do
      expect { build_profile(endpoint_type: 'foo') }
        .to raise_exception(Cybersourcery::CybersourceryError)
    end

    it 'raises an exception if any setting is missing' do
      expect { build_profile(access_key: nil) }
        .to raise_exception(Cybersourcery::CybersourceryError)
    end
  end

  describe '#local' do
    context 'when it is one of Profile::LOCALES' do
      it 'must be one of Profile::LOCALES' do
        profile = build_profile(
          locale: described_class::LOCALES.keys.shuffle.first
        )
        expect(profile).to be_valid
      end
    end

    context 'when it is not one of Profile::LOCALES' do
      it 'must not be one of Profile::LOCALES' do
        expect { build_profile(locale: 'ab-cd') }
          .to raise_exception(Cybersourcery::CybersourceryError)
      end
    end

    context 'when it is nil' do
      it 'must not be one of Profile::LOCALES' do
        expect { build_profile(locale: nil) }
          .to raise_exception(Cybersourcery::CybersourceryError)
      end
    end
  end

  # The arguments to transaction_url are normally not needed, as they are
  # determined from the environment. The arguments are to facilitate testing
  # only.
  describe '#transaction_url' do
    it 'returns the proxy URL, if in test env and proxy URL is defined' do
      profile = build_profile
      transaction_url = profile.transaction_url('http://localhost:5556')
      expect(transaction_url).to eq 'http://localhost:5556/silent/pay'
    end

    it 'returns "test" service URL, if in test env and proxy URL not defined' do
      profile = build_profile(service: 'test')
      transaction_url = profile.transaction_url(nil)
      expect(transaction_url).to eq \
        'https://testsecureacceptance.cybersource.com/silent/pay'
    end

    it 'returns "test" service URL, if not in test env and using test server' do
      profile = build_profile(service: 'test')
      transaction_url = profile.transaction_url(nil, 'development')
      expect(
        transaction_url
      ).to eq 'https://testsecureacceptance.cybersource.com/silent/pay'
    end

    it 'returns "live" service URL, if not in test env and using live server' do
      profile = build_profile(service: 'live')
      transaction_url = profile.transaction_url(nil, 'development')
      expect(
        transaction_url
      ).to eq 'https://secureacceptance.cybersource.com/silent/pay'
    end
  end
end
