# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require File.expand_path("../lib/", __FILE__)

Gem::Specification.new do |s|
  s.authors     = ["Carolina Gonzalez"]
  s.email       = ["carolina.nicole.gonzalez@gmail.com"]
  s.homepage    = "https://github.com/thecarsgone/fifty_sukajans"
  s.summary     = "This is a gem that will provide you with information on the top 50 sukajan jackets on eBay."
  s.description = "Replicates a search function on eBay via scraping, provides cursory information on items via the CLI, and allows users to launch eBay pages from the program."

  s.name        = "fifty_sukajans"
  s.files       =  Dir['lib/**/*.rb']

  s.version     = "1.0.0.pre"
  s.executables = ['fifty-sukajans']
  s.require_path = ['lib', 'lib/fifty-sukajans']


  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "launchy", "~> 2.4"
  s.add_development_dependency "nokogiri"


end
