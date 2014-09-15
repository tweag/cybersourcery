module Cybersourcery
  class ReasonCodeChecker
    REASON_CODE_EXPLANATIONS = {
      '100' => 'Successful transaction.',
      '101' => 'Declined: The request is missing one or more required fields.',
      '102' => 'Declined: One or more fields in the request contains invalid data',
      '104' => 'Declined: An identical authorization request has been submitted within the past 15 minutes',
      '150' => 'Error: General system failure. Please wait a few minutes and try again.',
      '151' => 'Error: The request was received but there was a server timeout. Please wait a few minutes and try again.',
      '152' => 'Error: The request was received, but a service did not finish running in time. Please wait a few minutes and try again.',
      '200' => 'Declined: The authorization request was approved by the issuing bank but declined by CyberSource because it did not pass the Address Verification Service (AVS) check',
      '201' => 'Declined: The issuing bank has questions about the request. Please contact your credit card company.',
      '202' => 'Declined: Expired card. Please verify your card information, or try a different card.',
      '203' => 'Declined: General decline of the card. No other information provided by the issuing bank. Please try a different card.',
      '204' => 'Declined: Insufficient funds in the account. Please try a different card.',
      '205' => 'Declined: Stolen or lost card',
      '207' => 'Declined: Issuing bank unavailable. Please wait a few minutes and try again.',
      '208' => 'Declined: Inactive card or card not authorized for card-not-present transactions. Please try a different card.',
      '209' => 'Declined: American Express Card Identification Digits (CID) did not match. Please verify your card information, or try a different card.',
      '210' => 'Declined: The card has reached the credit limit. Please try a different card.',
      '211' => 'Declined: Invalid card verification number. Please verify your card information, or try a different card.',
      '221' => 'Declined: The customer matched an entry on the processors negative file.',
      '230' => 'Declined: The authorization request was approved by the issuing bank but declined by CyberSource because it did not pass the card verification (CV) check',
      '231' => 'Declined: Invalid account number, or the card type is not valid for the number provided. Please try a different card.',
      '232' => 'Declined: The card type is not accepted by the payment processor.  Please try a different card.',
      '233' => 'Declined: General decline by the processor. Please try a different card.',
      '234' => 'Declined: There is a problem with your CyberSource merchant configuration',
      '235' => 'Declined: The requested amount exceeds the originally authorized amount.',
      '236' => 'Declined: Processor failure. Please wait a few minutes and try again.',
      '237' => 'Declined: The authorization has already been reversed',
      '238' => 'Declined: The authorization has already been captured',
      '239' => 'Declined: The requested transaction amount must match the previous transaction amount.',
      '240' => 'Declined: The card type sent is invalid or does not correlate with the credit card number',
      '241' => 'Declined: The request ID is invalid',
      '242' => 'Declined: You requested a capture, but there is no corresponding, unused authorization record. Occurs if there was not a previously successful authorization request or if the previously successful authorization has already been used by another capture request',
      '243' => 'Declined: The transaction has already been settled or reversed',
      '246' => 'Declined: The capture or credit is not voidable because the capture or credit information has already been submitted to your processor. Or, you requested a void for a type of transaction that cannot be voided',
      '247' => 'Declined: You requested a credit for a capture that was previously voided',
      '250' => 'Error: The request was received, but there was a timeout at the payment processor. Please try again in a few minutes.',
      '251' => "Declined: The Pinless Debit card's use frequency or maximum amount per use has been exceeded.",
      '254' => 'Declined: Account is prohibited from processing stand-alone refunds.',
      '400' => 'Declined: Fraud score exceeds threshold.',
      '450' => 'Apartment number missing or not found. Please verify your address information and try again.',
      '451' => 'Insufficient address information. Please verify your address information and try again.',
      '452' => 'House/Box number not found on street. Please verify your address information and try again.',
      '453' => 'Multiple address matches were found. Please verify your address information and try again.',
      '454' => 'P.O. Box identifier not found or out of range. Please verify your address information and try again.',
      '455' => 'Route service identifier not found or out of range. Please verify your address information and try again.',
      '456' => 'Street name not found in Postal code. Please verify your address information and try again.',
      '457' => 'Postal code not found in database. Please verify your address information and try again.',
      '458' => 'Unable to verify or correct address. Please verify your address information and try again.',
      '459' => 'Multiple international address matches were found. Please verify your address information and try again.',
      '460' => 'Address match not found. Please verify your address information and try again.',
      '461' => 'Error: Unsupported character set.',
      '475' => 'Error: The cardholder is enrolled in Payer Authentication. Please authenticate the cardholder before continuing with the transaction.',
      '476' => 'Error: Encountered a Payer Authentication problem. Payer could not be authenticated.',
      '480' => 'The order is marked for review by the Cybersource Decision Manager',
      '481' => 'Error: The order has been rejected by the Cybersource Decision Manager',
      '520' => 'Declined: The authorization request was approved by the issuing bank but declined by CyberSource based on your Smart Authorization settings.'
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
