module Cybersourcery
  class ReasonCodeChecker

    # thank you FoxyCart!
    # https://forum.foxycart.com/discussion/311/customizing-payment-gateway-reason-code-messages-in-foxycart/p1
    REASON_CODE_EXPLANATIONS = {
      '100' => 'Successful transaction.',
      '101' => 'Declined: The request is missing one or more required fields.',
      '102' => 'Declined: One or more fields in the request contains invalid data',
      '104' => 'Declined: An identical authorization request has been submitted within the past 15 minutes',
      '150' => 'Error: General system failure.',
      '151' => 'Error: The request was received but there was a server timeout. This error does not include timeouts between the client and the server',
      '152' => 'Error: The request was received, but a service did not finish running in time.',
      '200' => 'The authorization request was approved by the issuing bank but declined by CyberSource because it did not pass the Address Verification Service (AVS) check',
      '201' => 'The issuing bank has questions about the request. You do not receive an authorization code programmatically, but you might receive one verbally by calling the processor',
      '202' => 'Expired card. You might also receive this if the expiration date you provided does not match the date the issuing bank has on file',
      '203' => 'General decline of the card. No other information provided by the issuing bank.',
      '204' => 'Insufficient funds in the account',
      '205' => 'Stolen or lost card',
      '207' => 'Issuing bank unavailable',
      '208' => 'Inactive card or card not authorized for card-not-present transactions',
      '209' => 'American Express Card Identification Digits (CID) did not match',
      '210' => 'The card has reached the credit limit.',
      '211' => 'Invalid card verification number.',
      '221' => 'The customer matched an entry on the processors negative file.',
      '230' => 'The authorization request was approved by the issuing bank but declined by CyberSource because it did not pass the card verification (CV) check',
      '231' => 'Invalid account number',
      '232' => 'The card type is not accepted by the payment processor',
      '233' => 'General decline by the processor',
      '234' => 'There is a problem with your CyberSource merchant configuration',
      '235' => 'The requested amount exceeds the originally authorized amount. Occurs, for example, if you try to capture an amount larger than the original authorization amount',
      '236' => 'Processor failure.',
      '237' => 'The authorization has already been reversed',
      '238' => 'The authorization has already been captured',
      '239' => 'The requested transaction amount must match the previous transaction amount.',
      '240' => 'The card type sent is invalid or does not correlate with the credit card number',
      '241' => 'The request ID is invalid',
      '242' => 'You requested a capture, but there is no corresponding, unused authorization record. Occurs if there was not a previously successful authorization request or if the previously successful authorization has already been used by another capture request',
      '243' => 'The transaction has already been settled or reversed',
      '246' => 'The capture or credit is not voidable because the capture or credit information has already been submitted to your processor. Or, you requested a void for a type of transaction that cannot be voided',
      '247' => 'You requested a credit for a capture that was previously voided',
      '250' => 'Error: The request was received, but there was a timeout at the payment processor'
    }

    def self.run(reason_code)
      REASON_CODE_EXPLANATIONS.fetch(
        reason_code,
        "Declined: unknown reason (code #{reason_code})"
      )
    end

    def self.run!(reason_code)
      if reason_code == '100'
        self.run(reason_code)
      else
        raise Cybersourcery::CybersourceryError, self.run(reason_code)
      end
    end
  end
end
