# encoding: utf-8

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "marv"
  gem.executables = ["marv"]
  gem.homepage = "http://hardpixel.github.io/marv"
  gem.license = "MIT"
  gem.summary = %Q{A command-line tool for developing wordpress themes and plugins}
  gem.description = %Q{A toolkit for bootstrapping and developing WordPress themes and plugins using Sass, LESS, and CoffeeScript.}
  gem.email = "info@hardpixel.eu"
  gem.authors = ["Jonian Guveli", "Olibia Tsati"]
  # dependencies defined in Gemfile
  gem.files.include Dir.glob('**/*')
end

Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "marv #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('CHANGELOG*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
