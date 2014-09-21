# encoding: utf-8
require_relative "test_helper"

class HelpersTest < ActionView::TestCase
  def test_number_with_delimiter
    assert_equal "1 240,503", number_with_delimiter(1240.503)
  end

  def test_number_to_currency
    assert_equal "1 240,50 грн.", number_to_currency(1240.503, unit: "грн.")
  end

  def test_number_to_percentage
    assert_equal "90%", number_to_percentage(90)
  end

  def test_number_with_precision
    assert_equal "123,45", number_with_precision(123.45334)
  end

  def test_number_to_human
    assert_equal "123,5 Тисяч", number_to_human(123456.45334)
  end

  def test_number_to_human_size
    assert_equal "795 байтів", number_to_human_size(795)
  end

  def setup
    @locale = I18n.locale
    I18n.locale = :uk
  end

  def teardown
    I18n.locale = @locale
  end
end

