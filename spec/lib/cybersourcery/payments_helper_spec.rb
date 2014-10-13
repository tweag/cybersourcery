require 'rails_helper'

describe Cybersourcery::PaymentsHelper, type: 'helper' do
  describe '#countries' do
    it 'returns a hash of countries' do
      countries = helper.countries
      expect(countries.size).to eq 249

      expect(
        countries.any? { |k, v| k == 'United States' && v == 'US' }
      ).to be true
    end
  end

  describe '#us_states' do
    it 'returns a hash of US states' do
      states = helper.us_states
      expect(states.size).to eq 50

      expect(
        states.any? { |k, v| k == 'Rhode Island' && v == 'RI' }
      ).to be true
    end
  end

  describe '#card_types' do
    it 'returns a hash of accepted card types' do
      card_types = helper.card_types
      expect(card_types.size).to eq 4

      expect(
        card_types.any? { |k, v| k == 'American Express' && v == '003' }
      ).to be true
    end
  end
end
