require "test_helper"

module I18n
  class TransferTranslationsTest < I18nTest
    def test_transfer_translations
      I18n.backend.store_translations(:en, hello: "hi")
      I18n.backend.store_translations(:de, hello: "Hallo")
      I18n.mova.transfer_translations!
      assert_equal "hi", I18n.t(:hello)
      assert_equal "Hallo", I18n.t(:hello, locale: :de)
    end

    def test_reload
      I18n.backend.store_translations(:en, hello: "hi")
      I18n.reload!
      assert_equal "missing translation: en.hello", I18n.t(:hello)

      I18n.load_path << File.expand_path("../locale/en.yml", __FILE__)
      I18n.reload!
      assert_equal "Hi!", I18n.t(:hello)

      I18n.load_path = []
      I18n.reload!
      assert_equal "missing translation: en.hello", I18n.t(:hello)
    end
  end
end
