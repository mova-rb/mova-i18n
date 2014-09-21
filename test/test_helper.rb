require "bundler/setup"
require "mova-i18n"

require "minitest"
Minitest.autorun

require "rspec/mocks"

RSpec::Mocks.configuration.syntax = :expect

module RSpec::Mocks
  remove_const :MockExpectationError
  # treat as Minitest failure, not an exception
  MockExpectationError = Class.new(Minitest::Assertion)
end

module I18n
  module Test
    module RSpecMocksForMinitest
      include RSpec::Mocks::ExampleMethods

      def before_setup
        RSpec::Mocks.setup
        super
      end

      def after_teardown
        begin
          RSpec::Mocks.verify
        ensure
          RSpec::Mocks.teardown
        end
        super
      end
    end
  end

  class I18nTest < Minitest::Test
    include I18n::Test::RSpecMocksForMinitest

    def setup
      @default_translator = I18n.mova.translator.clone
      @default_interpolator = I18n.mova.interpolator.clone
      @default_i18n_backend = I18n.backend.clone
      @default_load_path = I18n.load_path.dup

      I18n.enforce_available_locales = false
      @default_locale = I18n.locale
      I18n.locale = :en
    end

    def teardown
      I18n.mova.translator = @default_translator
      I18n.mova.interpolator = @default_interpolator
      I18n.backend = @default_i18n_backend
      I18n.load_path = @default_load_path
      I18n.locale = @default_locale
      I18n.reload!
    end
  end
end
