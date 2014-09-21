require "test_helper"

module I18n
  class TranslateTest < I18nTest
    def test_current_locale
      assert_equal "foo in en", I18n.t(:foo)
    end

    def test_option_locale
      assert_equal "foo in de", I18n.t(:foo, locale: "de")
    end

    def test_string_key
      assert_equal "foo in en", I18n.t("foo")
    end

    def test_dot_separated_key
      assert_equal "qux in en", I18n.t(:"bar.baz.qux")
    end

    def test_missing_translation
      assert_equal "missing translation: en.missing", I18n.t(:missing)
    end

    def test_raise_on_missing_translation
      assert_raises(I18n::MissingTranslationData) { I18n.t(:missing, raise: true) }
    end

    def test_throws_on_missing_translation
      assert_throws(:exception) { I18n.t(:missing, throw: true) }
    end

    def test_interpolation
      assert_equal "my foobar", I18n.t(:bar, locale: :de, bar: "foobar")
    end

    def test_interpolation_with_missing_placeholder
      assert_raises(I18n::MissingInterpolationArgument) { I18n.t(:bar, locale: :de) }
    end

    def test_locale_fallbacks
      fallback_resolver = double
      expect(fallback_resolver).to receive(:[]).with(:ru).and_return([:ru, :en])
      expect(I18n).to receive(:fallbacks).and_return(fallback_resolver)
      assert_equal "foo in en", I18n.t(:foo, locale: :ru)
    end

    def test_locale_fallbacks_suppressed
      expect(I18n).not_to receive(:fallbacks)
      assert_equal "missing translation: ru.foo", I18n.t(:foo, locale: :ru, fallback: true)
    end

    def setup
      super
      I18n.mova.translator.put(
        en: {foo: "foo in en", bar: {baz: {qux: "qux in en"}}},
        de: {foo: "foo in de", bar: "my %{bar}"}
      )
    end
  end
end
