# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w(
  controllers/application.js
  controllers/hello_controller.js
  controllers/modal_controller.js
  controllers/star_rating_controller.js
  controllers/index.js
  chartkick.js
  application.js
  application.css
)
