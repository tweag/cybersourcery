require 'rails_helper'

feature 'Cybersourcery configuration' do
  scenario 'configures Cybersourcery with a valid yaml file' do
    expect(Cybersourcery.configuration.profiles['pwksgem']['name']).to eq 'PromptWorks Gem'
    expect(Cybersourcery.configuration.profiles['acptfee']['currency']).to eq 'USD'
    expect(Cybersourcery.configuration.sop_proxy_url).to eq 'http://localhost:5555'
  end
end

