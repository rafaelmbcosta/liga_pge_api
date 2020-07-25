$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "season/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "season"
  spec.version     = Season::VERSION
  spec.authors     = ["Rafael Costa"]
  spec.email       = [""]
  spec.homepage    = "http://liga-pge.herokuapp.com"
  spec.summary     = 'Module to control seasons'
  spec.description = 'update the most recent season and throw some events'
  spec.license     = "Rafael Costa"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.4", ">= 5.2.4.3"

  spec.add_development_dependency "sqlite3"
end
