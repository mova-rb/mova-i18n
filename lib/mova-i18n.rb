require "i18n"
require "mova"
require "mova/interpolation/sprintf"
require "mova-i18n/config"
require "mova-i18n/bridge"

module I18n
  def self.mova
    Mova::I18nConfig
  end

  # make sure we can safely call `I18n.fallbacks` even
  # if `I18n::Backend::Fallbacks` was not required
  unless respond_to?(:fallbacks)
    def self.fallbacks
      @fallbacks ||= Hash.new { |h,k| h[k] = [k] }
    end
  end

  class << self
    def translate(key, options = nil)
      options = options && options.dup || {}

      locale = options[:locale] || config.locale
      locale_with_fallbacks =
        if options[:fallback]
          # suppress locale fallbacks (inverted due to I18n fallbacks implementation)
          [locale]
        else
          fallbacks[locale]
        end

      if (default = options[:default]) && !default.is_a?(Hash)
        defaults = Array(default)
        options[:default] = defaults.last.is_a?(String) ? defaults.pop : nil
        key = Array(key).concat(defaults)
      end

      if (count = options[:count])
        zero_plural_key = :zero if count == 0
        plural_key = mova.pluralizer(locale).call(count)
        key = Array(key).each_with_object([]) do |key, memo|
          memo << Mova::Scope.join(key, zero_plural_key) if zero_plural_key
          memo << Mova::Scope.join(key, plural_key)
          memo << key
        end
      end

      if (scope = options[:scope])
        scope = Array(scope)
        key = Array(key).map do |key|
          Mova::Scope.join(scope + [key])
        end
      end

      result = mova.translator.get(key, locale_with_fallbacks, options)

      if result.is_a?(String) && !(interpolation_keys = options.keys - RESERVED_KEYS).empty?
        mova.interpolator.call(result, options)
      else
        result
      end
    end
    alias_method :t, :translate

    def exists?(key, locale = config.locale)
      locale_with_fallbacks = fallbacks[locale]
      result = mova.translator.get([key], locale_with_fallbacks, default: "")
      Mova.presence(result)
    end

    def reload!
      super
      mova.transfer_translations!
    end
  end
end
