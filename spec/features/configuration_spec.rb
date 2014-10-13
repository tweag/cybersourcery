require 'rails_helper'

feature 'Cybersourcery configuration' do
  scenario 'configures Cybersourcery with a valid yaml file' do
    expect(
      Cybersourcery.configuration.profiles['pwksgem']['name']
    ).to eq 'PromptWorks Gem'

    expect(
      Cybersourcery.configuration.profiles['pwksgem']['currency']
    ).to eq 'USD'

    expect(
      Cybersourcery.configuration.sop_live_url
    ).to eq 'https://secureacceptance.cybersource.com'

    expect(
      Cybersourcery.configuration.sop_test_url
    ).to eq 'https://testsecureacceptance.cybersource.com'
  end
end
