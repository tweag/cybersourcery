require 'rails_helper'

feature 'Payments' do
  scenario 'configures Cybersourcery with a valid yaml file' do
    expect(Cybersourcery.configuration.profiles['pwksgem']['name']).to eq 'PromptWorks Gem'
    expect(Cybersourcery.configuration.profiles['acptfee']['currency']).to eq 'USD'
    expect(Cybersourcery.configuration.mock_silent_order_post_url).to eq 'http://localhost:4567'
  end
end

