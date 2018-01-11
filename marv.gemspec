# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: marv 0.6.5 ruby lib

Gem::Specification.new do |s|
  s.name = "marv".freeze
  s.version = "0.6.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jonian Guveli".freeze, "Olibia Tsati".freeze]
  s.date = "2018-01-11"
  s.description = "A toolkit for bootstrapping and developing WordPress themes and plugins using Sass, LESS, and CoffeeScript.".freeze
  s.email = "info@hardpixel.eu".freeze
  s.executables = ["marv".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    "CHANGELOG.md",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
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
    "lib/marv.rb",
    "lib/marv/cli.rb",
    "lib/marv/cli/project.rb",
    "lib/marv/cli/server.rb",
    "lib/marv/global.rb",
    "lib/marv/project/actions.rb",
    "lib/marv/project/builder.rb",
    "lib/marv/project/builder/assets.rb",
    "lib/marv/project/builder/engines.rb",
    "lib/marv/project/builder/functions.rb",
    "lib/marv/project/builder/templates.rb",
    "lib/marv/project/create.rb",
    "lib/marv/project/guard.rb",
    "lib/marv/project/guard/assets.rb",
    "lib/marv/project/guard/config.rb",
    "lib/marv/project/guard/functions.rb",
    "lib/marv/project/guard/templates.rb",
    "lib/marv/project/project.rb",
    "lib/marv/server/actions.rb",
    "lib/marv/server/create.rb",
    "lib/marv/server/server.rb",
    "marv.gemspec"
  ]
  s.homepage = "http://hardpixel.github.io/marv".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.3".freeze
  s.summary = "A command-line tool for developing wordpress themes and plugins".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<guard>.freeze, ["< 2.9", "~> 2.8"])
      s.add_runtime_dependency(%q<guard-livereload>.freeze, ["~> 2.4"])
      s.add_runtime_dependency(%q<thor>.freeze, ["~> 0.19"])
      s.add_runtime_dependency(%q<sprockets>.freeze, ["~> 2.12"])
      s.add_runtime_dependency(%q<childprocess>.freeze, ["~> 0.5"])
      s.add_runtime_dependency(%q<mysql2>.freeze, ["~> 0.3"])
      s.add_runtime_dependency(%q<uglifier>.freeze, ["~> 2.7"])
      s.add_runtime_dependency(%q<sass>.freeze, ["~> 3.4"])
      s.add_runtime_dependency(%q<less>.freeze, ["~> 2.6"])
      s.add_runtime_dependency(%q<coffee-script>.freeze, ["~> 2.3"])
      s.add_runtime_dependency(%q<therubyracer>.freeze, ["~> 0.12"])
      s.add_runtime_dependency(%q<rubyzip>.freeze, ["~> 1.1"])
      s.add_runtime_dependency(%q<autoprefixer-rails>.freeze, ["~> 7.2"])
      s.add_development_dependency(%q<rdoc>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<jeweler>.freeze, [">= 0"])
    else
      s.add_dependency(%q<guard>.freeze, ["< 2.9", "~> 2.8"])
      s.add_dependency(%q<guard-livereload>.freeze, ["~> 2.4"])
      s.add_dependency(%q<thor>.freeze, ["~> 0.19"])
      s.add_dependency(%q<sprockets>.freeze, ["~> 2.12"])
      s.add_dependency(%q<childprocess>.freeze, ["~> 0.5"])
      s.add_dependency(%q<mysql2>.freeze, ["~> 0.3"])
      s.add_dependency(%q<uglifier>.freeze, ["~> 2.7"])
      s.add_dependency(%q<sass>.freeze, ["~> 3.4"])
      s.add_dependency(%q<less>.freeze, ["~> 2.6"])
      s.add_dependency(%q<coffee-script>.freeze, ["~> 2.3"])
      s.add_dependency(%q<therubyracer>.freeze, ["~> 0.12"])
      s.add_dependency(%q<rubyzip>.freeze, ["~> 1.1"])
      s.add_dependency(%q<autoprefixer-rails>.freeze, ["~> 7.2"])
      s.add_dependency(%q<rdoc>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<jeweler>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<guard>.freeze, ["< 2.9", "~> 2.8"])
    s.add_dependency(%q<guard-livereload>.freeze, ["~> 2.4"])
    s.add_dependency(%q<thor>.freeze, ["~> 0.19"])
    s.add_dependency(%q<sprockets>.freeze, ["~> 2.12"])
    s.add_dependency(%q<childprocess>.freeze, ["~> 0.5"])
    s.add_dependency(%q<mysql2>.freeze, ["~> 0.3"])
    s.add_dependency(%q<uglifier>.freeze, ["~> 2.7"])
    s.add_dependency(%q<sass>.freeze, ["~> 3.4"])
    s.add_dependency(%q<less>.freeze, ["~> 2.6"])
    s.add_dependency(%q<coffee-script>.freeze, ["~> 2.3"])
    s.add_dependency(%q<therubyracer>.freeze, ["~> 0.12"])
    s.add_dependency(%q<rubyzip>.freeze, ["~> 1.1"])
    s.add_dependency(%q<autoprefixer-rails>.freeze, ["~> 7.2"])
    s.add_dependency(%q<rdoc>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<jeweler>.freeze, [">= 0"])
  end
end

