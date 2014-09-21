require "test_helper"

module I18n
  class TransliterateTest < I18nTest
    def test_default_transliterator
      assert_equal "AEroskobing", I18n.transliterate("Ærøskøbing")
    end

    def test_hash_transliterator
      assert_equal "leto", I18n.transliterate("лeто", locale: :ru)
    end

    def test_proc_transliterator
      assert_equal "mova", I18n.transliterate("мова", locale: :uk)
    end

    def setup
      super
      I18n.mova.translator.put({
        ru: {i18n: {transliterate: {rule: {"л" => "l", "е" => "e", "т" => "t", "о" => "o"}}}},
        uk: {i18n: {transliterate: {rule: ->(string) do
          map = {"м" => "m", "о" => "o", "в" => "v", "а" => "a"}
          string.each_char.map { |char| map[char] }.join
        end}}}
      })
    end
  end
end
