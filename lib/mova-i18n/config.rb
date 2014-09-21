module Mova
  module I18nConfig
    class << self
      attr_writer :translator, :interpolator

      # Transfer translations from `I18n::Backend::Simple`, since we can have enumerate all keys
      # here. Other key-value storages should be passed to `I18n.mova.translator` directly.
      #
      # @note Clears all current translations in `I18n.mova.translator.storage`. Use
      #   {Mova::Storage::Readonly} to protect certain storages if you have a chain of them.
      def transfer_translations!
        # calling protected methods
        I18n.backend.send(:init_translations) if I18n.backend.respond_to?(:init_translations, true)
        if I18n.backend.respond_to?(:translations, true)
          translations = I18n.backend.send(:translations)
          translator.storage.clear
          translator.put(translations)
        end
      end

      def translator
        @translator ||= I18nTranslator.new
      end

      def interpolator
        @interpolator ||= I18nInterpolator.new
      end

      def pluralizer(locale)
        @pluralizers ||= {}
        @pluralizers[locale] ||= translator.storage.read("#{locale}.i18n.plural.rule") ||
                                 ->(count){ count == 1 ? :one : :other }
      end
    end
  end
end
