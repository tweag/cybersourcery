$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'cybersourcery/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'cybersourcery'
  s.version     = Cybersourcery::VERSION
  s.authors     = ['Michael Toppa']
  s.email       = ['public@toppa.com']
  s.homepage    = 'https://github.com/promptworks/cybersourcery'
  s.summary     = %q{A pain removal gem for working with Cybersource Secure Acceptance Silent Order POST}
  s.description = %q{Cybersourcery takes care of the most difficult aspects of working with Cybersource in Rails. It makes as few assumptions as possible about your business requirements, allowing you to use any subset of features appropriate to your needs.}

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '>= 3.1'
  s.add_dependency 'ruby-hmac', '>= 0.4'
  s.add_development_dependency 'bundler', '>= 1.6'
  s.add_development_dependency 'rake', '>= 10.3'
  s.add_development_dependency 'capybara', '>= 2.4'
  s.add_development_dependency 'poltergeist', '>= 1.5'
  s.add_development_dependency 'rspec-rails', '>= 3.0'
  s.add_development_dependency 'sqlite3', '>= 1.3'
  s.add_development_dependency 'slim-rails', '>= 2.1.5'
  s.add_development_dependency 'bootstrap-sass', '>= 3.2.0.1'
  s.add_development_dependency 'simple_form', '>= 3.1.0.rc2'
  s.add_development_dependency 'sass-rails', '>= 4.0'
  s.add_development_dependency 'coffee-rails', '>= 4.0'
  s.add_development_dependency 'jquery-rails', '>= 3.1'
  s.add_development_dependency 'dotenv-rails', '>= 0.11'
  s.add_development_dependency 'cybersourcery_testing', '>= 0.0.2'
end


