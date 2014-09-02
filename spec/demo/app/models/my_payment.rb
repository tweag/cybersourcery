class MyPayment < Cybersourcery::Payment
  attr_accessor :bill_to_phone, :card_cvn, :card_expiry_dummy
  validates_presence_of :card_cvn, :card_expiry_dummy
end
