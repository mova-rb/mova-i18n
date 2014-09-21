require "test_helper"

module I18n
  class MovaConfigTest < I18nTest
    def test_assigns_translator
      translator = double
      I18n.mova.translator = translator
      assert_equal translator, I18n.mova.translator
    end

    def test_assigns_interpolator
      interpolator = double
      I18n.mova.interpolator = interpolator
      assert_equal interpolator, I18n.mova.interpolator
    end
  end
end
