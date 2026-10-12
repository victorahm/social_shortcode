source 'https://rubygems.org'

# Declare your gem's dependencies in social_shortcode.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# The host application provides Rails; pin it here for local development and
# the test dummy app. CamaleonCMS 2.9.x is tested against Rails 7.1 - 8.1.
gem 'rails', '~> 8.1'

# CamaleonCMS 2.9.x parses several of its own JSON configs in a comment-tolerant
# way that only works on the json 2.x line: json 3 rejects the // comments in
# camaleon's bundled plugin configs. (CamaleonCMS master fixes this properly and
# pins the same constraint until then — see camaleon-cms' Gemfile.)
gem 'json', '< 3'

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
