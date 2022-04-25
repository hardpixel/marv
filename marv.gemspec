# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "marv/version"

Gem::Specification.new do |spec|
  spec.name          = "marv"
  spec.license       = "MIT"
  spec.version       = Marv::VERSION
  spec.authors       = ["Jonian Guveli", "Olibia Tsati"]
  spec.email         = ["info@hardpixel.eu"]

  spec.summary       = %q{Toolkit for developing WordPress themes and plugins}
  spec.description   = %q{A toolkit for bootstrapping and developing WordPress themes and plugins using Sass, LESS, and CoffeeScript.}
  spec.homepage      = "https://hardpixel.github.io/marv"

  spec.files         = Dir['*'].flat_map { |d| Dir["{#{d}/**/*,[A-Z]*}"] if d != 'spec' && d != 'pkg' }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "guard", "~> 2.8", "< 2.9"
  spec.add_dependency "guard-livereload", "~> 2.4"
  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "sprockets", "~> 3.7"
  spec.add_dependency "childprocess", "~> 0.5"
  spec.add_dependency "mysql2", "~> 0.3"
  spec.add_dependency "uglifier", "~> 4.1"
  spec.add_dependency "sass", "~> 3.4"
  spec.add_dependency "less", "~> 2.6"
  spec.add_dependency "coffee-script", "~> 2.3"
  spec.add_dependency "mini_racer", "~> 0.2"
  spec.add_dependency "rubyzip", "~> 1.1"
  spec.add_dependency "autoprefixer-rails", "~> 10.4"
  spec.add_dependency "tilt", "!= 1.3", "~> 1.1"
  spec.add_dependency "pry", ">= 0.13"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
