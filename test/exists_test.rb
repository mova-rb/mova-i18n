require "test_helper"

module I18n
  class ExistsTest < I18nTest
    def test_existing_key
      assert I18n.exists?(:foo)
    end

    def test_existing_key_with_explisit_locale
      assert I18n.exists?(:foo, :en)
    end

    def test_non_existing_key
      refute I18n.exists?(:bar)
    end

    def test_locale_fallbacks
      fallback_resolver = double
      expect(fallback_resolver).to receive(:[]).with(:ru).and_return([:ru, :en])
      expect(I18n).to receive(:fallbacks).and_return(fallback_resolver)
      assert I18n.exists?(:foo, :ru)
    end

    def setup
      super
      I18n.mova.translator.put(en: {foo: "foo in en"})
    end
  end
end
