require File.expand_path("../lib/", __FILE__)

Gem::Specification.new do |s|
  s.name        = "fifty_sukajans"
  s.authors     = ["Carolina Gonzalez"]
  s.email       = ["carolina.nicole.gonzalez@gmail.com"]
  s.homepage    = "https://github.com/thecarsgone/fifty_sukajans"
  s.summary     = "This is a gem that will provide you with information on the top 50 sukajan jackets on eBay."
  s.description = "Replicates a search function on eBay via scraping, provides cursory information on items via the CLI, and allows users to launch eBay pages from the program."

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = ["lib", "lib/fifty_sukajans"]

  s.executables = ["fifty-sukajans"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "launchy"
  spec.add_development_dependency "nokogiri"


end
