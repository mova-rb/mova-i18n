# encoding: utf-8
require "test_helper"

module I18n
  class ScopeTest < I18nTest
    def test_simple_scope
      assert_equal "qux in en", I18n.t("baz.qux", scope: "bar")
    end

    def test_dot_separated_scope
      assert_equal "qux in en", I18n.t("qux", scope: "bar.baz")
    end

    def test_scope_array
      assert_equal "qux in en", I18n.t("qux", scope: %w(bar baz))
    end

    def setup
      super
      I18n.mova.translator.put(
        en: {foo: "foo in en", bar: {baz: {qux: "qux in en"}}},
        de: {foo: "foo in de", bar: "my %{bar}"},
        uk: {table: {one: "%{count} стіл", few: "%{count} столи", many: "%{count} столів"}}
      )
    end
  end
end
