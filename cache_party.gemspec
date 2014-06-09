$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cache_party/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cache_party"
  s.version     = CacheParty::VERSION
  s.authors     = ["Robert Roach"]
  s.email       = ["rjayroach@gmail.com"]
  s.homepage    = "http://rjayroach.github.io"
  s.summary     = "Cache 3rd party data and assets"
  s.description = "Transparently cache data from 3rd party websites, such as Facebook and link to a user model"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.1.0"
  #s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "koala"
  s.add_dependency "sucker_punch", '~> 1.0.0'
  #s.add_dependency "omniauth-facebook"


  s.add_development_dependency "sqlite3"
  s.add_development_dependency "geminabox-rake"

  # added by mcp_build
  s.add_dependency 'mcp_common' #, '>= 0.12.0'
  s.add_dependency 'dry_auth' #, '>= 0.12.0'

end
