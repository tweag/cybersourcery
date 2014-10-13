require 'rails_helper'

describe Cybersourcery::MerchantDataSerializer do
  let(:bacon_ipsum) do
    'Bacon ipsum dolor sit amet pork chop short ribs tail, pork loin '\
    'hamburger pastrami pork brisket boudin tenderloin salami filet '\
    'mignon shankle bacon rump. Sirloin shankle beef ribs rump, '\
    'frankfurter tail jerky ground round landjaeger jowl pork chop pork '\
    'belly filet mignon. Filet mignon flank short ribs, bresaola ham '\
    'boudin leberkas sirloin turducken biltong pork chop pork doner. '\
    'Chicken prosciutto frankfurter strip steak tri-tip sausage flank '\
    'shankle hamburger tenderloin landjaeger short loin bresaola. Swine '\
    'ball tip pork ham, pork loin biltong turducken jowl doner fatback '\
    'flank landjaeger shoulder. Turkey tail filet mignon, porchetta ball '\
    'tip sirloin biltong leberkas pig ham tenderloin. Bacon filet mignon '\
    'cow, turducken meatball venison spare ribs swine frankfurter '\
    'capicola. Ball tip leberkas strip steak boudin doner ribeye. Pork '\
    'sirloin salami boudin tenderloin, meatball swine chicken. Jerky jowl '\
    'hamburger strip steak turducken pig brisket andouille cow pork sausage '\
    'kevin rump shankle. Corned beef landjaeger frankfurter doner, turkey '\
    'shankle pastrami chicken salami bacon beef ribs pig brisket. Ham '\
    'shankle shank tenderloin spare ribs. Ham ribeye chuck spare ribs pig. '\
    'Ham hamburger tenderloin pork chop drumstick t-bone short loin rump '\
    'jowl pork loin.'
  end

  let(:merchant_data) do
    {
      long_string: bacon_ipsum[0..975], longer_string: bacon_ipsum[0..1221]
    }
  end

  describe '#serialize' do
    it 'serializes the data to json in fields of 100 characters or less' do
      serializer = described_class.new
      serialized_data = serializer.serialize(merchant_data)
      expect(serialized_data.size).to eq 23

      expect(
        serialized_data[:merchant_defined_data1]
      ).to eq "{\"long_string\":\"#{bacon_ipsum[0..83]}"

      expect(
        serialized_data[:merchant_defined_data23]
      ).to eq "#{bacon_ipsum[-80..-48]}\"}"
    end

    it 'raises an exception if the count of merchant fields exceeds 100' do
      serializer = described_class.new(90)
      expect do
        serializer.serialize(merchant_data)
      end.to raise_exception Cybersourcery::CybersourceryError
    end

    it 'raises an exception if the count of merchant fields is less than 1' do
      serializer = described_class.new(0)
      expect do
        serializer.serialize(merchant_data)
      end.to raise_exception Cybersourcery::CybersourceryError
    end
  end

  describe '#deserialize' do
    it 'deserializes the merchant data fields back to the original hash' do
      serializer = described_class.new
      serialized_data = serializer.serialize(merchant_data)
      params = {
        'access_key' => 'ACCESS_KEY',
        'profile_id' => 'pwksgem',
        'payment_method' => 'sale'
      }.merge! serialized_data

      expect(serializer.deserialize(params)).to eq merchant_data
    end
  end
end
