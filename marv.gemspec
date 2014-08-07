# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "marv"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonian Guveli", "Olibia Tsati"]
  s.date = "2014-08-07"
  s.description = "A toolkit for bootstrapping and developing WordPress themes using Sass, LESS, and CoffeeScript."
  s.email = "info@hardpixel.eu"
  s.executables = ["marv"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "CHANGELOG.md",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/marv",
    "features/step_definitions/marv_steps.rb",
    "features/support/env.rb",
    "layouts/bramble/functions/functions.php.erb",
    "layouts/bramble/images/screenshot.png",
    "layouts/bramble/includes/options.php.erb",
    "layouts/bramble/javascripts/admin.coffee",
    "layouts/bramble/javascripts/admin.js",
    "layouts/bramble/javascripts/theme.coffee",
    "layouts/bramble/javascripts/theme.js",
    "layouts/bramble/stylesheets/_header.scss.erb",
    "layouts/bramble/stylesheets/style.scss.erb",
    "layouts/bramble/templates/sample-template.php",
    "layouts/config/config.th",
    "layouts/config/config.wp",
    "layouts/default/functions/functions.php.erb",
    "layouts/default/images/screenshot.png",
    "layouts/default/includes/filters-admin.php.erb",
    "layouts/default/includes/filters.php.erb",
    "layouts/default/includes/helpers.php.erb",
    "layouts/default/javascripts/admin.coffee",
    "layouts/default/javascripts/admin.js",
    "layouts/default/javascripts/theme.coffee",
    "layouts/default/javascripts/theme.js",
    "layouts/default/stylesheets/_header.scss.erb",
    "layouts/default/stylesheets/style.scss.erb",
    "layouts/default/templates/404.php.erb",
    "layouts/default/templates/archive.php.erb",
    "layouts/default/templates/author.php.erb",
    "layouts/default/templates/footer.php",
    "layouts/default/templates/header.php",
    "layouts/default/templates/index.php",
    "layouts/default/templates/page.php",
    "layouts/default/templates/partials/comments.php.erb",
    "layouts/default/templates/partials/content-none.php.erb",
    "layouts/default/templates/partials/content-page.php",
    "layouts/default/templates/partials/content-single.php",
    "layouts/default/templates/partials/content.php.erb",
    "layouts/default/templates/partials/searchform.php.erb",
    "layouts/default/templates/partials/sidebar.php",
    "layouts/default/templates/search.php.erb",
    "layouts/default/templates/single.php",
    "lib/guard/marv/assets.rb",
    "lib/guard/marv/config.rb",
    "lib/guard/marv/functions.rb",
    "lib/guard/marv/templates.rb",
    "lib/marv.rb",
    "lib/marv/builder.rb",
    "lib/marv/cli.rb",
    "lib/marv/engines.rb",
    "lib/marv/error.rb",
    "lib/marv/generator.rb",
    "lib/marv/guard.rb",
    "lib/marv/installer.rb",
    "lib/marv/project.rb",
    "lib/marv/version.rb",
    "marv-0.3.0.gem",
    "marv.gemspec",
    "spec/lib/marv/project_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://hardpixel.github.io/marv"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "A tool for developing wordpress themes"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, [">= 0.19.1"])
      s.add_runtime_dependency(%q<guard>, [">= 2.2.1"])
      s.add_runtime_dependency(%q<guard-livereload>, [">= 2.3.0"])
      s.add_runtime_dependency(%q<sprockets>, [">= 2.12.0"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 1.1.6"])
      s.add_runtime_dependency(%q<rack>, [">= 1.5.2"])
      s.add_runtime_dependency(%q<rack-legacy>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<rack-rewrite>, [">= 1.5.0"])
      s.add_runtime_dependency(%q<sass>, [">= 3.3.0"])
      s.add_runtime_dependency(%q<less>, [">= 2.6.0"])
      s.add_runtime_dependency(%q<coffee-script>, [">= 2.3.0"])
      s.add_runtime_dependency(%q<therubyracer>, [">= 0.12.0"])
      s.add_runtime_dependency(%q<rb-fsevent>, [">= 0.9.4"])
      s.add_runtime_dependency(%q<uglifier>, [">= 2.5.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<aruba>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<thor>, [">= 0.19.1"])
      s.add_dependency(%q<guard>, [">= 2.2.1"])
      s.add_dependency(%q<guard-livereload>, [">= 2.3.0"])
      s.add_dependency(%q<sprockets>, [">= 2.12.0"])
      s.add_dependency(%q<rubyzip>, [">= 1.1.6"])
      s.add_dependency(%q<rack>, [">= 1.5.2"])
      s.add_dependency(%q<rack-legacy>, [">= 1.0.0"])
      s.add_dependency(%q<rack-rewrite>, [">= 1.5.0"])
      s.add_dependency(%q<sass>, [">= 3.3.0"])
      s.add_dependency(%q<less>, [">= 2.6.0"])
      s.add_dependency(%q<coffee-script>, [">= 2.3.0"])
      s.add_dependency(%q<therubyracer>, [">= 0.12.0"])
      s.add_dependency(%q<rb-fsevent>, [">= 0.9.4"])
      s.add_dependency(%q<uglifier>, [">= 2.5.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<aruba>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<thor>, [">= 0.19.1"])
    s.add_dependency(%q<guard>, [">= 2.2.1"])
    s.add_dependency(%q<guard-livereload>, [">= 2.3.0"])
    s.add_dependency(%q<sprockets>, [">= 2.12.0"])
    s.add_dependency(%q<rubyzip>, [">= 1.1.6"])
    s.add_dependency(%q<rack>, [">= 1.5.2"])
    s.add_dependency(%q<rack-legacy>, [">= 1.0.0"])
    s.add_dependency(%q<rack-rewrite>, [">= 1.5.0"])
    s.add_dependency(%q<sass>, [">= 3.3.0"])
    s.add_dependency(%q<less>, [">= 2.6.0"])
    s.add_dependency(%q<coffee-script>, [">= 2.3.0"])
    s.add_dependency(%q<therubyracer>, [">= 0.12.0"])
    s.add_dependency(%q<rb-fsevent>, [">= 0.9.4"])
    s.add_dependency(%q<uglifier>, [">= 2.5.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<aruba>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

