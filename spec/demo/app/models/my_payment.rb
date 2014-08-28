class MyPayment < Cybersourcery::Payment
  attr_accessor :bill_to_phone, :card_cvn
  validates_presence_of :card_cvn
end
