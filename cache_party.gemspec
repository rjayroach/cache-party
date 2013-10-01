$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cache_party/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cache_party"
  s.version     = CacheParty::VERSION
  s.authors     = ["Robert Roach"]
  s.email       = ["rjayroach@gmail.com"]
  s.homepage    = "http://www.maxcole.com"
  s.summary     = "A plugable engine for an Mcp App"
  s.description = "No Description."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "koala"
  s.add_dependency "sucker_punch", '~> 1.0.0'
  #s.add_dependency "omniauth-facebook"


  s.add_development_dependency "sqlite3"

  # added by mcp_build
  s.add_dependency 'mcp_common' #, '>= 0.12.0'
  s.add_dependency 'mcp_auth' #, '>= 0.12.0'

end
