require 'rails_helper'

describe Cybersourcery::CybersourceParamsNormalizer do
  describe '#run' do
    it "removes 'req_' from Cybersource response params" do
      params = {
        'req_card_expiry_date' => '06-2015',
        'req_bill_to_address_state' => 'PA',
        'transaction_id' => '4095759873410176195663',
        'auth_response' => '100'
      }

      Cybersourcery::CybersourceParamsNormalizer.run(params)

      expect(params).to eq ({
        'req_card_expiry_date' => '06-2015',
        'req_bill_to_address_state' => 'PA',
        'card_expiry_date' => '06-2015',
        'bill_to_address_state' => 'PA',
        'transaction_id' => '4095759873410176195663',
        'auth_response' => '100'
      })
    end
  end
end
