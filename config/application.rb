require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CopyProject
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.after_initialize do
      if Rails.env != 'test'
        Rails.application.load_tasks
        Rake::Task["copy:copy_from_airtable_to_json"].invoke
        config.x.folder = './storage/airtable/'
      end
      if Rails.env == 'test'
        default_folder = './storage/airtable/test/'
        config.x.folder = default_folder
        unless File.directory?(default_folder)
          FileUtils.mkdir_p(default_folder)
        end
        File.write(default_folder + 'airtable-data.json', [{key:"intro.created_at",copy:"Intro created on {created_at, datetime}"},{key:"intro.updated_at",copy:"Intro updated on {updated_at, datetime}"},{key:"greeting",copy:"Hi {name}, welcome to {app}!"}].to_json)
      end
    end
    config.api_only = true
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
