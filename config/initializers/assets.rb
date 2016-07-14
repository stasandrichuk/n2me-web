# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( new_layout.css new_layout.js devise.css products/style.css music/style.css music/scripts.js schedule/tv_listing.js schedule/search.js)

Rails.application.config.assets.precompile += %w( frontpage.css frontpage.js )

# Rails.application.config.assets.precompile += %w( moment-timezone.js )
# Rails.application.config.assets.precompile += %w( moment-timezone-utils.js )
