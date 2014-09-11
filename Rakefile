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
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
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

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features)

task :default => :spec

require 'rdoc/task'

RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "marv #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end