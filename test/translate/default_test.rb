require "test_helper"

module I18n
  class DefaultTest < I18nTest
    def test_string_default
      assert_equal "my default", I18n.t(:missing, default: "my default")
    end

    def test_symbol_default
      assert_equal "foo in en", I18n.t(:missing, default: :foo)
    end

    def test_empty_hash_default
      assert_equal({}, I18n.t(:missing, default: {}))
    end

    def test_symbol_default_with_scope
      assert_equal "qux in en", I18n.t(:missing, scope: "bar.baz", default: :qux)
    end

    def test_array_symbol_default
      assert_equal "foo in en", I18n.t(:missing, default: [:missing2, :foo])
    end

    def test_array_symbol_default_missing
      assert_equal "missing translation: en.missing", I18n.t(:missing, default: [:missing2, :missing3])
    end

    def test_array_symbol_default_with_scope
      assert_equal "qux in en", I18n.t(:missing, scope: "bar.baz", default: [:missing2, :qux])
    end

    def test_array_symbol_trailing_string_default
      assert_equal "my default", I18n.t(:missing, default: [:missing2, "my default"])
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
