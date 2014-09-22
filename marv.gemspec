# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "marv"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonian Guveli", "Olibia Tsati"]
  s.date = "2014-09-22"
  s.description = "A toolkit for bootstrapping and developing WordPress themes and plugins using Sass, LESS, and CoffeeScript."
  s.email = "info@hardpixel.eu"
  s.executables = ["marv"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".document",
    "CHANGELOG.md",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/marv",
    "layouts/config/global.rb",
    "layouts/config/project.rb",
    "layouts/config/router.php",
    "layouts/config/server.rb",
    "layouts/config/wp-config.php",
    "layouts/plugin/assets/images/screenshot.png",
    "layouts/plugin/assets/javascripts/admin.coffee",
    "layouts/plugin/assets/javascripts/admin.js",
    "layouts/plugin/assets/javascripts/plugin.coffee",
    "layouts/plugin/assets/javascripts/plugin.js",
    "layouts/plugin/assets/stylesheets/plugin.scss",
    "layouts/plugin/functions/plugin.php",
    "layouts/theme/assets/images/screenshot.png",
    "layouts/theme/assets/javascripts/admin.coffee",
    "layouts/theme/assets/javascripts/admin.js",
    "layouts/theme/assets/javascripts/theme.coffee",
    "layouts/theme/assets/javascripts/theme.js",
    "layouts/theme/assets/stylesheets/_header.scss",
    "layouts/theme/assets/stylesheets/style.scss",
    "layouts/theme/functions/functions.php",
    "layouts/theme/includes/filters-admin.php",
    "layouts/theme/includes/filters.php",
    "layouts/theme/includes/helpers.php",
    "layouts/theme/templates/footer.php",
    "layouts/theme/templates/header.php",
    "layouts/theme/templates/index.php",
    "layouts/theme/templates/page.php",
    "layouts/theme/templates/pages/404.php",
    "layouts/theme/templates/pages/archive.php",
    "layouts/theme/templates/pages/author.php",
    "layouts/theme/templates/pages/search.php",
    "layouts/theme/templates/partials/comments.php",
    "layouts/theme/templates/partials/content-none.php",
    "layouts/theme/templates/partials/content-page.php",
    "layouts/theme/templates/partials/content-single.php",
    "layouts/theme/templates/partials/content.php",
    "layouts/theme/templates/partials/searchform.php",
    "layouts/theme/templates/partials/sidebar.php",
    "layouts/theme/templates/single.php",
    "lib/guard/marv/assets.rb",
    "lib/guard/marv/config.rb",
    "lib/guard/marv/functions.rb",
    "lib/guard/marv/templates.rb",
    "lib/marv.rb",
    "lib/marv/cli/cli.rb",
    "lib/marv/cli/project.rb",
    "lib/marv/cli/server.rb",
    "lib/marv/engines.rb",
    "lib/marv/global.rb",
    "lib/marv/project/builder.rb",
    "lib/marv/project/create.rb",
    "lib/marv/project/guard.rb",
    "lib/marv/project/link.rb",
    "lib/marv/project/package.rb",
    "lib/marv/project/project.rb",
    "lib/marv/server/actions.rb",
    "lib/marv/server/create.rb",
    "lib/marv/server/server.rb",
    "marv.gemspec"
  ]
  s.homepage = "http://hardpixel.github.io/marv"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "A command-line tool for developing wordpress themes and plugins"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, [">= 0.19.1"])
      s.add_runtime_dependency(%q<guard-livereload>, [">= 2.3.0"])
      s.add_runtime_dependency(%q<sprockets>, [">= 2.12.0"])
      s.add_runtime_dependency(%q<childprocess>, [">= 0.3.5"])
      s.add_runtime_dependency(%q<mysql2>, [">= 0.3.15"])
      s.add_runtime_dependency(%q<uglifier>, [">= 2.5.0"])
      s.add_runtime_dependency(%q<sass>, [">= 3.3.0"])
      s.add_runtime_dependency(%q<less>, [">= 2.6.0"])
      s.add_runtime_dependency(%q<coffee-script>, [">= 2.3.0"])
      s.add_runtime_dependency(%q<therubyracer>, [">= 0.12.0"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 1.1.6"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
    else
      s.add_dependency(%q<thor>, [">= 0.19.1"])
      s.add_dependency(%q<guard-livereload>, [">= 2.3.0"])
      s.add_dependency(%q<sprockets>, [">= 2.12.0"])
      s.add_dependency(%q<childprocess>, [">= 0.3.5"])
      s.add_dependency(%q<mysql2>, [">= 0.3.15"])
      s.add_dependency(%q<uglifier>, [">= 2.5.0"])
      s.add_dependency(%q<sass>, [">= 3.3.0"])
      s.add_dependency(%q<less>, [">= 2.6.0"])
      s.add_dependency(%q<coffee-script>, [">= 2.3.0"])
      s.add_dependency(%q<therubyracer>, [">= 0.12.0"])
      s.add_dependency(%q<rubyzip>, [">= 1.1.6"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    end
  else
    s.add_dependency(%q<thor>, [">= 0.19.1"])
    s.add_dependency(%q<guard-livereload>, [">= 2.3.0"])
    s.add_dependency(%q<sprockets>, [">= 2.12.0"])
    s.add_dependency(%q<childprocess>, [">= 0.3.5"])
    s.add_dependency(%q<mysql2>, [">= 0.3.15"])
    s.add_dependency(%q<uglifier>, [">= 2.5.0"])
    s.add_dependency(%q<sass>, [">= 3.3.0"])
    s.add_dependency(%q<less>, [">= 2.6.0"])
    s.add_dependency(%q<coffee-script>, [">= 2.3.0"])
    s.add_dependency(%q<therubyracer>, [">= 0.12.0"])
    s.add_dependency(%q<rubyzip>, [">= 1.1.6"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
  end
end

