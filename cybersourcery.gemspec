$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cybersourcery/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cybersourcery"
  s.version     = Cybersourcery::VERSION
  s.authors     = ["Michael Toppa"]
  s.email       = ["public@toppa.com"]
  s.homepage    = "https://github.com/promptworks/cybersourcery"
  s.summary     = %q{A pain removal gem for working with Cybersource Secure Acceptance Silent Order POST}
  s.description = %q{}

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.4"
  s.add_dependency 'ruby-hmac', '~> 0.4.0'
  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency 'capybara', '~> 2.4.1'
  s.add_development_dependency 'selenium-webdriver', '~> 2.42.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0.0'
  s.add_development_dependency "sqlite3"
end
