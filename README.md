# Cybersourcery

A pain removal gem for working with Cybersource Secure Acceptance Silent Order POST.

## Features

Cybersourcery takes care of the most difficult aspects of working with Cybersource in Rails. It makes as few assumptions as possible about your business requirements, allowing you to use any subset of features appropriate to your needs.

* It handles signing fields and checking signatures.
* It provides a non-persisted model for the credit card form, making it easy to use Rails' model validations with your form.
* It provides non-technical, human readable messages for the Cybersource error codes.
* It provides several form helper methods, for a country select list, US states select list, date fields appropriate for credit card expiry dates, and helpers for use with Simple Form.
* It provides optional data security features for submitting data from your shopping cart to your credit card payment form, to ensure no one has tampered with fields such as the payment amount.
* If you have merchant data that exceeds the 100 character limit on the Cybersource `merchant_defined_data` fields, it provides features that support seamlessly serializing and deserializing your data across multiple merchant data fields.
* If you use it in conjunction with [the Cybersourcery Testing gem](https://github.com/promptworks/cybersourcery_testing), you can set up repeatable feature/integration tests. The testing gem uses a proxy server and VCR, so you do not need to repeatedly hit the Cybersource test service itself in your tests.

## Demo versions

If you download the gem with its development dependencies, you will get a working demo site, in spec/demo. Alternately, [a stand-alone, working demo site is available](https://github.com/promptworks/cybersourcery_demo_site).

## Installation and setup

1. Add it to your Gemfile:

  ```ruby
  gem 'cybersourcery'
  ```

2. Run the config generator:

  ```console
  rails generate cybersourcery:config
  ```
  
  This generates 2 files: `config/cybersourcery_profiles.yml` and `config/initializers/cybersourcery.rb`.

3. Add information about your Cybersource profiles to the `config/cybersourcery_profiles.yml` file. You must first create these profiles in the Cybersource Business Center. We recommend that **you do not check this file into version control**, since it will contain sensitive data about your Cybersource profiles.

  * Each profile in the yml file must have a key that corresponds to a "Profile ID" in the Cybersource Business Center. Each profile has the following fields:
    * name: a human readable name
    * service: `test` or `live`
    * access_key: the access key for the profile
    * secret_key: the secret key for the profile
    * success_url: this is an optional field - if you provide it, you can redirect users to it after a successful transaction (it can be an absolute or relative URL)
    * transaction_type: a Cybersource transaction type, for example: `sale,create_payment_token`
    * endpoint_type: indicates the URL endpoint appropriate for the transaction - supported values are:
      * `standard`
      * `create_payment_token`
      * `update_payment_token`
      * `iframe_standard`
      * `iframe_create_payment_token`
      * `iframe_update_payment_token`
    * payment_method: `card` or `echeck`
    * locale: any locale supported by Cybersource, for example, `en-us`
    * currency: any currency supported by Cybersource, for example, `USD`
    * unsigned_field_names: a comma separated list of the fields that will not be signed in the transaction - this typically includes all the fields in the credit card payment form

## Usage

### Setting up your credit card payment form

#### The controller method for displaying the form

In your controller method for displaying your credit card form, you can add a line like this:

```ruby
@payment = Cybersourcery::Container.get_payment('pwksgem', params, 'MyPayment')
```

The first argument is the profile ID for the Cybersource profile you want to use.

The second argument is typically the controller's `params` field. You can of course substitute an analogous data structure. A couple important notes:

* For a successful transaction, it must include an `amount`.
* It should not include any of fields listed in the `cybersourcery_profiles.yml` file. They will be automatically added to the credit card form's hidden inputs and will be included in the list of signed fields. 

The third argument is optional. It can be the name of a subclass you create, derived from [the Payment model](https://github.com/promptworks/cybersourcery/blob/master/lib/cybersourcery/payment.rb) included with Cybersourcery. This non-persisted model has attributes for the minimal set of fields in a credit card form, including billing address information. You can create a subclass for adding billing address attributes, phone number, etc. [Here is an example subclass](https://github.com/promptworks/cybersourcery/blob/master/spec/demo/app/models/my_payment.rb).

#### The view for the form

Cybersourcery imposes no specific approach to how you create your form, but provides several helper methods you can use. They are best understood by [reviewing an example](https://github.com/promptworks/cybersourcery/blob/master/spec/demo/app/views/payments/pay.html.slim). The example uses Simple Form, and although Simple Form is not required, Cybersourcery includes several helpers for making it very easy to work with Simple Form.

Key points:

* The form `action` URL is determined based on the information provided in `cybersourcery_profiles.yml`.
* Calling the `add_signed_fields` helper method is crucial, for passing the signature and signed fields to Cybersource.
* Cybersourcery provides support for HTML5 front-end validation, but no specific approach to front-end form validation is required. As shown in the example, you can leverage the non-persisted Payment model to indicate required fields.
* The optional call to the `add_expiry_date_fields` helper method makes it easy to include a month and date picker in your form that's [appropriate for indicating credit card expiry dates](http://baymard.com/blog/how-to-format-expiration-date-fields). Used in conjunction with [this javascript from the demo project](https://github.com/promptworks/cybersourcery/blob/master/spec/demo/app/assets/javascripts/payments.js.coffee), it will then submit a date in the user-unfriendly format that Cybersource requires.
* The javascript file in the demo project also provides dynamic switching of the input type for the "State" field, based on whether the US is selected as the country (it provides a select list of states for the US, or a text input field for other countries).
* The `field_pattern` and `field_validation_message` methods in the [PaymentsHelper](https://github.com/promptworks/cybersourcery/blob/master/lib/cybersourcery/payments_helper.rb) include only one pattern matching requirement, for the credit card number format. You can add more pattern matching rules, [like this](http://stackoverflow.com/questions/10471535/override-rails-helpers-with-access-to-original#10525284), as you see fit. 

## Handling the transaction response from Cybersource

1. Add the following to your controller:

  ```ruby
  skip_before_filter :verify_authenticity_token, only: :confirm
  before_action :normalize_cybersource_params, only: :confirm

  [...]

  private

  def normalize_cybersource_params
    Cybersourcery::CybersourceParamsNormalizer.run(params)
  end
  ```

  Since the POST is from Cybersource, there is no reason to check for a Rails authenticity token.
  
  The `CybersourceParamsNormalizer` copies and adds param names that start with "req_", and removes "req_" from them, so they have consistent naming across contexts, which simplifies internal handling.
  
2. A minimal method for handling the response would look like this:

  ```ruby
    def confirm
      signature_checker = Cybersourcery::Container.get_cybersource_signature_checker('pwksgem', params)
      signature_checker.run!
      flash.now[:notice] = Cybersourcery::ReasonCodeChecker::run!(params[:reason_code])
    rescue Cybersourcery::CybersourceryError => e
      flash.now[:alert] = e.message
    end
    ```

There are two possible exceptions that can be thrown here, and the `rescue` block will catch either of them. One possibility is that the signatures fail to match, which indicates data tampering. The other possibility is that the transaction failed, due to an expired credit card, or some other reason. In either case, an appropriate flash message will be created (a flash `alert` for an error, and a flash `notice` for a successful transaction). The ReasonCodeChecker provides user friendly explanations of why the transaction failed

If you prefer to not have exceptions thrown for error conditions, you can call `run` (without the exclamation point) on the SignatureChecker or the ReasonCodeChecker.

3. Typically, you will want to display the credit card form again if there is a problem with the transaction, so the user can try again. See the [PaymentsController's `confirm` method in the demo project](https://github.com/promptworks/cybersourcery/blob/master/spec/demo/app/controllers/payments_controller.rb) for an example of how to do this.

4. Optionally, you can redirect the user to a different URL after a successful transaction. This can be determined dynamically from the profile data. This can be useful if the page shown to users after a transaction needs to vary by the Cybersource profile.

  ```ruby
  profile = Cybersourcery::Profile.new('pwksgem')
  redirect_to profile.success_url
  ```

### Optional: Securely submitting the transaction amount to your credit card form

Cybersourcery provides an optional feature to simplify securely populating the `amount` field in the credit card payment form. In the demo project, the controller method for displaying the credit card form accepts a POST. It receives data from an extremely simple "shopping cart" form. Cybersourcery signs and verifies the submission from the cart page to the credit card form page in the same manner as the credit card form submission to Cybersource. The reason for this is the `amount` field should be a signed field in the Cybersource transaction, and in a typical use case, the `amount` value will be determined before the user arrives at the credit card form. So we need a way to securely pass the `amount` to the credit card form. The typical solution for this is to not pass the amount through the front-end, but with Cybersource, this can complicate the process of making sure the `amount` field is included in the signed fields (so we'll know it has not been tampered with) . Cybersourcery's signing solution provides a secure way to handle the `amount` through the front-end. Note you can also include `merchant_defined_data` fields, and any other fields you might want, for signing.

Here is an example, for creating `@signed_fields` to include in a simple shopping cart form that will submit to the credit card payment form:

  ```ruby
  def new
    cart_fields = {amount: 100, merchant_defined_data1: 'foo' }
    cart_signer = Cybersourcery::Container.get_cart_signer('pwksgem', session, cart_fields)
    @signed_fields = cart_signer.run
  end
  ```  

If the credit card transaction fails, and you send your user back to the credit card form, Cybersourcery makes it easy to re-create the state of the cart form submission that precedes the display of the credit card form. See the `setup_payment_form` method in [the demo project's PaymentsController](https://github.com/promptworks/cybersourcery_demo_site/blob/master/app/controllers/payments_controller.rb).

### Optional: Serializing merchant defined data

Cybersource's `merchant_defined_data` fields have a 100 character limit. If you need to use longer values (such as long URLs), Cybersourcery can serialize them across multiple fields for you, and deserialize them when the transaction is complete. See the demo project's `new` method in [the CartsController](https://github.com/promptworks/cybersourcery_demo_site/blob/master/app/controllers/carts_controller.rb) for a serializing example, and the `confirm` method in [the PaymentsController](https://github.com/promptworks/cybersourcery_demo_site/blob/master/app/controllers/payments_controller.rb) for a deserializing example.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cybersourcery/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
