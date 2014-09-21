module Mova
  # `I18nBridge` name to explicitly avoid collision with root namespace, so we
  # don't need to type `::I18n`.
  module I18nBridge
    module Translator
      def default(locales, keys, options)
        origin_locale = locales.first
        origin_key = keys.first

        if options[:raise]
          raise I18n::MissingTranslationData.new(origin_locale, origin_key, options)
        end

        if options[:throw]
          throw :exception, I18n::MissingTranslation.new(origin_locale, origin_key, options)
        end

        key_with_locale = Mova::Scope.join(origin_locale, origin_key)
        "missing translation: #{key_with_locale}"
      end

      def put(translations)
        super
        put_exact_translation(translations, "i18n.transliterate.rule")
        put_exact_translation(translations, "number.format")
        put_exact_translation(translations, "number.currency.format")
        put_exact_translation(translations, "number.human.format")
        put_exact_translation(translations, "number.human.decimal_units.units")
        put_exact_translation(translations, "number.percentage.format")
        put_exact_translation(translations, "number.precision.format")
      end

      # Stores exact value because {Mova::Translator#put} flattens hashes before writing
      # to the storage, while `I18n.transliterate` and Rails localization helpers rely on
      # ability of storing hashes as is.
      def put_exact_translation(translations, key)
        scope_path = Mova::Scope.split(key).map &:to_sym
        locales = translations.keys

        locales.each do |locale|
          full_path = [locale] + scope_path

          translation = full_path.inject(translations) do |memo, scope|
            memo[scope] || {}
          end

          unless translation == {}
            key_with_locale = Mova::Scope.join(full_path)
            storage.write(key_with_locale, translation)
          end
        end
      end
    end

    module Sprintf
      def missing_placeholder(placeholder, values, string)
        raise I18n::MissingInterpolationArgument.new(placeholder, values, string)
      end
    end
  end

  class I18nTranslator < Translator
    include I18nBridge::Translator
  end

  class I18nInterpolator < Interpolation::Sprintf
    include I18nBridge::Sprintf
  end
end
