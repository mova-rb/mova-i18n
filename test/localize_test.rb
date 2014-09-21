require "test_helper"

module I18n
  class LocalizeTest < I18nTest
    def date
      Date.new(2014, 6, 3)
    end

    def test_implicit_format
      assert_equal "2014-06-03", I18n.l(date)
    end

    def test_explicit_symbol_format
      assert_equal "Jun 03", I18n.l(date, format: :short)
      assert_equal "June 03, 2014", I18n.l(date, format: :long)
    end

    def test_explicit_string_format
      assert_equal "3 June 2014", I18n.l(date, format: "%-d %B %Y")
    end

    def time
      Time.utc(2014, 6, 3, 13, 15, 30)
    end

    def test_implicit_format_time
      assert_equal "Tue, 03 Jun 2014 13:15:30 +0000", I18n.l(time)
    end

    def test_explicit_symbol_format_time
      assert_equal "03 Jun 13:15", I18n.l(time, format: :short)
      assert_equal "June 03, 2014 13:15", I18n.l(time, format: :long)
    end

    def test_explicit_string_format_time
      assert_equal "3 June 2014", I18n.l(time, format: "%-d %B %Y")
    end

    def setup
      super
      I18n.mova.translator.put(en: {
        date: {
          formats: {default: "%Y-%m-%d", short: "%b %d", long: "%B %d, %Y"},
          day_names: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
          abbr_day_names: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
          month_names: [nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
          abbr_month_names: [nil, "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
          order: [:year, :month, :day]
        },
        time: {
          formats: {default: "%a, %d %b %Y %H:%M:%S %z", short: "%d %b %H:%M", long: "%B %d, %Y %H:%M"},
          am: "am",
          pm: "pm"
        }
      })
    end
  end
end
