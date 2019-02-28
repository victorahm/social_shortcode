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
  s.summary     = ": Summary of SocialShortcode."
  s.description = ": Description of SocialShortcode."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "camaleon_cms", "~> 2.0"

  s.add_development_dependency "sqlite3"
end
