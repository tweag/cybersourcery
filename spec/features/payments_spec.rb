require 'rails_helper'

feature 'Payments' do
  context 'Form does not pass client side validation' do
    scenario 'Fails to submit the payment form when the fields are not filled in', js: true do
      visit new_cart_path
      click_button 'commit' # submit the cart form
      click_button 'commit' # submit the payment form

      # this is relying on HTML5 validations, which Capybara cannot detect, so check the page header
      expect(page).to have_content 'New payment'
    end
  end

  context 'Form passes client side validation' do
    before do
      visit new_cart_path
      click_button 'commit'
      fill_in 'bill_to_forename', with: 'Michael'
      fill_in 'bill_to_surname', with: 'Toppa'
      select '6', from: 'payment_card_expiry_dummy_2i'
      select '2015', from: 'payment_card_expiry_dummy_1i'
      fill_in 'card_cvn', with: '110'
      select 'Visa', from: 'card_type'
      fill_in 'bill_to_email', with: 'public@toppa.com'
      select 'United States', from: 'bill_to_address_country'
      fill_in 'bill_to_address_line1', with: '123 Happy St'
      fill_in 'bill_to_address_city', with: 'Havertown'
      select 'Pennsylvania', from: 'bill_to_address_state'
      fill_in 'bill_to_address_postal_code', with: '19083'
    end

    scenario 'Successfully completes a transaction with a valid credit card', js: true do
      fill_in 'card_number', with: '4111111111111111'
      click_button 'Submit'

      expect(page).to have_content 'Successful transaction'
    end

    # TODO: this test is currently failing because it depends on cookies being set, and the way
    # the tests are running right now, we end up on a different server for the /confirm page, so the
    # cookies aren't there
    # scenario 'Fails to complete a transaction with an invalid credit card', js: true do
    #   page.driver.browser.set_cookie("auth_token=#{auth_token_value}")
    #   fill_in 'card_number', with: '4111111111111112'
    #   click_button 'Submit'
    #
    #   expect(page).to have_content 'Declined: One or more fields in the request contains invalid data'
    # end
  end
end
