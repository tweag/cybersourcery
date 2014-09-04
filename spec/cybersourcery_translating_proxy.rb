require 'rack/translating_proxy'

class CybersourceryTranslatingProxy < Rack::TranslatingProxy

  def target_host
    'http://localhost:5556'
  end

  def request_mapping
    {
      # the proxy                what the target host thinks it is
      'http://localhost:5555' => 'https://testsecureacceptance.cybersource.com',

      # local confirmation page          page where Cybersource redirects
      'http://localhost:3000/confirm' => 'http://tranquil-ocean-5865.herokuapp.com/confirm'
    }
  end
end
