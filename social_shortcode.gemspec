$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "social_shortcode/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "social_shortcode"
  s.version     = SocialShortcode::VERSION
  s.authors     = ["Victor Herrera"]
  s.email       = ["victorahm@gmail.com"]
  s.homepage    = ""
  s.summary     = "CamaleonCMS shortcodes for embedding social network media."
  s.description = "CamaleonCMS plugin that provides shortcodes for embedding " \
                  "multimedia content from social networks (YouTube, Instagram, X, TikTok, Facebook) " \
                  "inside CamaleonCMS pages and posts."
  s.license     = "MIT"

  s.required_ruby_version = ">= 3.2"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "camaleon_cms", "~> 2.9.4"

  s.add_development_dependency "sqlite3"
end
