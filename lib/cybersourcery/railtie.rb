require 'cybersourcery/payments_helper'

module Cybersourcery
  class Railtie < Rails::Railtie
    initializer 'Cybersourcery::ViewHelpers' do |app|
      ActionView::Base.send :include, PaymentsHelper
    end
  end
end
