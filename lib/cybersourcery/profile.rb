require 'active_support'
require 'active_support/core_ext/array/conversions.rb' # so we can use to_sentence

module Cybersourcery
  class Profile
    include ActiveModel::Validations

    VALID_ENDPOINTS = {
      standard: '/silent/pay',
      create_payment_token: '/silent/token/create',
      update_payment_token: '/silent/token/update',
      iframe_standard: '/silent/embedded/pay',
      iframe_create_payment_token: 'silent/embedded/token/create',
      iframe_update_payment_token: '/silent/embedded/token/update'
    }

    LOCALES = {
      'ar-xn' => 'Arabic',
      'km-kh' => 'Cambodia',
      'zh-hk' => 'Chinese - Hong Kong',
      'zh-mo' => 'Chinese - Maco',
      'zh-cn' => 'Chinese - Mainland',
      'zh-sg' => 'Chinese - Singapore',
      'zh-tw' => 'Chinese - Taiwan',
      'cz-cz' => 'Czech',
      'nl-nl' => 'Dutch',
      'en-us' => 'English - American',
      'en-au' => 'English - Australia',
      'en-gb' => 'English - Britain',
      'en-ca' => 'English - Canada',
      'en-ie' => 'English - Ireland',
      'en-nz' => 'English - New Zealand',
      'fr-ca' => 'French - Canada',
      'fr-fr' => 'French',
      'de-at' => 'German - Austria',
      'de-de' => 'German',
      'hu-hu' => 'Hungary',
      'id-id' => 'Indonesian',
      'it-it' => 'Italian',
      'ja-jp' => 'Japanese',
      'ko-kr' => 'Korean',
      'lo-la' => 'Lao People’s Democratic Republic',
      'ms-my' => 'Malaysian Bahasa',
      'tl-ph' => 'Philippines Tagalog',
      'pl-pl' => 'Polish',
      'pt-br' => 'Portuguese - Brazil',
      'ru-ru' => 'Russian',
      'sk-sk' => 'Slovakian',
      'es-us' => 'Spanish - American',
      'es-ar' => 'Spanish - Argentina',
      'es-cl' => 'Spanish - Chile',
      'es-co' => 'Spanish - Colombia',
      'es-mx' => 'Spanish - Mexico',
      'es-pe' => 'Spanish - Peru',
      'es-es' => 'Spanish',
      'th-th' => 'Thai',
      'tr-tr' => 'Turkish',
      'vi-vn' => 'Vietnamese',
    }

    attr_accessor :profile_id, :name, :service, :access_key, :secret_key, :success_url,
                  :transaction_type, :endpoint_type, :payment_method, :locale, :currency,
                  :unsigned_field_names
    validates_presence_of :profile_id, :name, :service, :access_key, :secret_key
    validates_inclusion_of :service, in: %w(test live), allow_nil: false
    validates_inclusion_of :endpoint_type, in: VALID_ENDPOINTS.keys, allow_nil: false
    validates_inclusion_of :payment_method, in: %w(card echeck), allow_nil: false
    validates_inclusion_of :locale, in: LOCALES.keys
    validates_format_of :currency, with: /\A[A-Z]{3}\Z/, allow_nil: false

    def initialize(attributes = {})
      attributes.each do |k,v|
        send "#{k}=", v
      end

      @endpoint_type = @endpoint_type.to_sym

      unless valid?
        raise Cybersourcery::CybersourceryError, self.errors.full_messages.to_sentence
      end
    end

    def transaction_url(proxy_url = ENV['CYBERSOURCERY_SOP_PROXY_URL'], env = Rails.env)
      if env == 'test' && proxy_url.present?
        "#{proxy_url}#{VALID_ENDPOINTS[@endpoint_type]}"
      elsif env == 'test' && proxy_url.blank?
        "#{Cybersourcery.configuration.sop_test_url}#{VALID_ENDPOINTS[@endpoint_type]}"
      elsif @service == 'test'
        "#{Cybersourcery.configuration.sop_test_url}#{VALID_ENDPOINTS[@endpoint_type]}"
      elsif @service == 'live'
        "#{Cybersourcery.configuration.sop_live_url}#{VALID_ENDPOINTS[@endpoint_type]}"
      else
        raise Cybersourcery::CybersourceryError, 'Invalid conditions for determining the transaction_url'
      end
    end
  end
end
