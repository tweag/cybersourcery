require 'rails_helper'

describe Cybersourcery::CybersourceSigner do
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

  let(:profile) do
    Cybersourcery::Profile.new(
      'profile_id' => 'pwksgem',
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
    )
  end

  let(:time) { Time.parse '2014-03-05 13:30:59:UTC' }
  let(:signature) { 'SUPER_SECURE_SIGNATURE' }
  let(:signer) { double :signer, signature: signature }
  subject(:cybersource_signer) { described_class.new(profile, signer) }

  describe '#add_signable_fields' do
    it 'adds signable fields' do
      params = {
        'amount' => '60',
        'merchant_defined_data1' => '2014',
        'merchant_defined_data100' => '2015',
        # this should be filtered out, since it's an unsigned field
        'bill_to_email' => 'joe@blow.com',
        # this should be filtered out, since it's an ignored field
        'action' => 'pay'
      }
      cybersource_signer.add_signable_fields(params)

      expect(cybersource_signer.signable_fields).to match a_hash_including(
        amount:                   '60',
        merchant_defined_data1:   '2014',
        merchant_defined_data100: '2015'
      )
    end
  end

  describe '#signed_fields' do
    it 'creates a signature' do
      signed_fields = cybersource_signer.signed_fields
      expect(signed_fields[:signature]).to eq signature
    end
  end

  describe '#form_fields' do
    let(:signed_field_names) do
      %w(
        access_key
        profile_id
        payment_method
        locale
        transaction_type
        currency
        unsigned_field_names
        transaction_uuid
        reference_number
        signed_date_time
        signed_field_names
      )
    end

    # This method is technically a reader, but acts like a writer.
    # form_fields is an attr_writer, which means you can set the value directly
    # yourself also.
    it 'sets form_fields' do
      cybersource_signer.time = time
      form_fields = cybersource_signer.form_fields

      # these two fields are generated each time
      expect(form_fields[:transaction_uuid].length).to eq 32
      expect(form_fields[:reference_number].length).to eq 32

      expect(cybersource_signer.form_fields).to match a_hash_including(
        access_key:           '839d4d3b1cef3e04bd2981997714803b',
        profile_id:           'pwksgem',
        payment_method:       'card',
        locale:               'en-us',
        transaction_type:     'sale',
        currency:             'USD',
        unsigned_field_names: unsigned_field_names.join(','),
        transaction_uuid:     form_fields[:transaction_uuid],
        reference_number:     form_fields[:reference_number],
        signed_field_names:   signed_field_names.join(','),
        signed_date_time:     time
      )
    end
  end

  describe '.signature_message' do
    let(:form_fields) { { foo: :bar, biz: :baz, wrong: :excluded } }
    subject { described_class.signature_message(form_fields, %i(biz foo)) }
    it { should eq 'biz=baz,foo=bar' }
  end
end

describe Cybersourcery::CybersourceSigner::Signer do
  describe '.signature' do
    let(:signature) { described_class.signature(data, secret_key) }

    [
      {
        secret_key:         '1234567890',
        data:               'my-data',
        expected_signature: 'wQSuKATsMj5xMgcAacRUlUULXuZfHx7dI7RH8i/HSJs='
      },
      {
        secret_key:         'fhgasfdkjbcjhaslxmfknakjflvkbasdkfjhsadkjfhsfkjh',
        data:               'gslkhqlqevlbeqsibelkvbqekjhbvjqlefbvljqkbv',
        expected_signature: 'jWe4FFfY0mPfJfKdnHiFU8DWI2fLTkJM4tk79XZuNQs='
      },
      {
        secret_key:         'FHGASFDKJBCJHASLXMFKNAKJFLVKBASDKFJHSADKJFHSFKJH',
        data:               'GSLKHQLQEVLBEQSIBELKVBQEKJHBVJQLEFBVLJQKBV',
        expected_signature: '9uUC+lPUja7zBgXnp4pddGKI6OwDM/f+ru4YDHh7cBs='
      }
    ].each do |example_data|
      context 'given some data' do
        let(:secret_key) { example_data[:secret_key] }
        let(:data) { example_data[:data] }
        let(:expected_signature) { example_data[:expected_signature] }

        it 'returns a signature' do
          expect(signature).to eq expected_signature
        end

        it 'returns a base64 encoded string' do
          expect { Base64.strict_decode64(signature) }.not_to raise_exception
        end
      end
    end
  end
end
