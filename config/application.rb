require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module OpenBudgets
  class Application < Rails::Application
    I18n.available_locales = [:en, :es, :el, :de, :fr]
    I18n.default_locale = :en

    #config.web_console.whitelisted_ips = '72.252.244.27'
  end
end
