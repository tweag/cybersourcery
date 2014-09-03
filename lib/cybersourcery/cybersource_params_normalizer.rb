module Cybersourcery
  class CybersourceParamsNormalizer
    def self.run(params)
      params.keys.each do |key|
        params[key[4..-1]] = params[key] if key =~ /^req_/
      end
    end
  end
end
