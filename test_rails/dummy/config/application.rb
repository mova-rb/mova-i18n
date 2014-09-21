require "action_controller/railtie"
require "mova-i18n"

module Dummy
  class Application < Rails::Application
    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = :en, :ru, :uk

    config.default_locale = :en

    config.secret_key_base = '-'
  end
end
