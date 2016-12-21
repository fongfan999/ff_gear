APP_CONFIG = YAML.load_file(Rails.root.join("config/settings.yml"))[Rails.env]

if Rails.env.production?
  APP_CONFIG.each do |key, value|
    APP_CONFIG[key] = ENV[key]
  end
end