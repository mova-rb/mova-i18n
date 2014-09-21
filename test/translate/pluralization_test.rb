# encoding: utf-8
require "test_helper"

module I18n
  class PluralizationTest < I18nTest
    def test_default_pluralizer
      assert_equal "22 bars", I18n.t(:bar, count: 22)
    end

    def test_pluralizer_from_load_path
      assert_equal "24 столи", I18n.t(:table, locale: :uk, count: 24)
    end

    def test_zero
      assert_equal "Нема нікого", I18n.t(:people, locale: :uk, count: 0)
    end

    def test_zero_fallback_to_others_plural_key
      assert_equal "0 bars", I18n.t(:bar, count: 0)
    end

    def test_fallback_to_non_plural_key
      assert_equal "foo", I18n.t(:foo, count: 1)
    end

    def test_with_default
      assert_equal "5 bars", I18n.t(:baz, count: 5, default: :bar)
    end

    def test_scope
      assert_equal "5 Tasten", I18n.t(:key, locale: :de, count: 5, scope: :nested)
    end

    def setup
      super
      I18n.mova.translator.put(
        en: {foo: "foo", bar: {one: "bar", other: "%{count} bars"}},
        uk: {table: {one: "%{count} стіл", few: "%{count} столи", many: "%{count} столів"},
            people: {zero: "Нема нікого", one: "%{count} людина", few: "%{count} людини", many: "%{count} людей"},
            i18n: {
              plural: {
                rule: lambda do |n|
                  mod10 = n % 10
                  mod100 = n % 100

                  if mod10 == 1 && mod100 != 11
                    :one
                  elsif [2, 3, 4].include?(mod10) && ![12, 13, 14].include?(mod100)
                    :few
                  elsif mod10 == 0 || (5..9).to_a.include?(mod10) || (11..14).to_a.include?(mod100)
                    :many
                  else
                    :other
                  end
                end
              }
            }
        },
        de: {nested: {key: {one: "1 Schlüssel", other: "%{count} Tasten"}}}
      )
    end
  end
end
