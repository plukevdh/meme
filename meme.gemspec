# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "meme/version"

Gem::Specification.new do |s|
  s.name        = "meme"
  s.version     = Meme::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Hodel"]
  s.email       = ["drbrain@segment7.net"]
  s.homepage    = "http://docs.seattlerb.org/meme_generator/"
  s.summary     = %q{A fun and fancy-free meme generator gem}
  s.description = %q{A simple library for generating memes from memegenerator.net}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('nokogiri')
  s.add_development_dependency('hoe')
end
