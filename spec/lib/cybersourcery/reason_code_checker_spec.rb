require 'rails_helper'

describe Cybersourcery::ReasonCodeChecker do
  describe '#run!' do
    it 'returns a success message if the transaction was successful' do
      expect(described_class.run!('100')).to eq 'Successful transaction.'
    end

    it 'raises an exception for a known error code' do
      expect { described_class.run!('101') }.to raise_exception(
        Cybersourcery::CybersourceryError,
        'Declined: The request is missing one or more required fields.'
      )
    end

    it 'raises an exception for an unknown error code' do
      expect { described_class.run!('600') }.to raise_exception(
        Cybersourcery::CybersourceryError,
        'Declined: unknown reason (code 600)'
      )
    end
  end
end
