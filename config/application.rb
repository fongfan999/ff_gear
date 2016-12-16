require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FoxFizz
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.i18n.default_locale = :vi
    config.time_zone = 'Hanoi'

    config.before_initialize do
      require_relative 'load_settings'
    end

    config.active_job.queue_adapter = :delayed_job
  end
end
