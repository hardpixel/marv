# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "marv"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonian Guveli", "Olibia Tsati"]
  s.date = "2014-09-11"
  s.description = "A toolkit for bootstrapping and developing WordPress themes and plugins using Sass, LESS, and CoffeeScript."
  s.email = "info@hardpixel.eu"
  s.executables = ["marv"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".rspec",
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
    "layouts/config/project-config.rb",
    "layouts/config/router.php.erb",
    "layouts/config/wp-config.php.erb",
    "layouts/theme/functions/functions.php.erb",
    "layouts/theme/images/screenshot.png",
    "layouts/theme/includes/filters-admin.php.erb",
    "layouts/theme/includes/filters.php.erb",
    "layouts/theme/includes/helpers.php.erb",
    "layouts/theme/javascripts/admin.coffee",
    "layouts/theme/javascripts/admin.js",
    "layouts/theme/javascripts/theme.coffee",
    "layouts/theme/javascripts/theme.js",
    "layouts/theme/stylesheets/_header.scss.erb",
    "layouts/theme/stylesheets/style.scss.erb",
    "layouts/theme/templates/404.php.erb",
    "layouts/theme/templates/archive.php.erb",
    "layouts/theme/templates/author.php.erb",
    "layouts/theme/templates/footer.php",
    "layouts/theme/templates/header.php",
    "layouts/theme/templates/index.php",
    "layouts/theme/templates/page.php",
    "layouts/theme/templates/partials/comments.php.erb",
    "layouts/theme/templates/partials/content-none.php.erb",
    "layouts/theme/templates/partials/content-page.php",
    "layouts/theme/templates/partials/content-single.php",
    "layouts/theme/templates/partials/content.php.erb",
    "layouts/theme/templates/partials/searchform.php.erb",
    "layouts/theme/templates/partials/sidebar.php",
    "layouts/theme/templates/search.php.erb",
    "layouts/theme/templates/single.php",
    "lib/guard/marv/assets.rb",
    "lib/guard/marv/config.rb",
    "lib/guard/marv/folders.rb",
    "lib/guard/marv/functions.rb",
    "lib/guard/marv/templates.rb",
    "lib/marv.rb",
    "lib/marv/builder.rb",
    "lib/marv/cli.rb",
    "lib/marv/engines.rb",
    "lib/marv/error.rb",
    "lib/marv/generator.rb",
    "lib/marv/guard.rb",
    "lib/marv/project.rb",
    "lib/marv/server.rb",
    "marv-0.3.1.gem",
    "marv.gemspec",
    "rdoc/Guard.html",
    "rdoc/Guard/MarvAssets.html",
    "rdoc/Guard/MarvConfig.html",
    "rdoc/Guard/MarvFolders.html",
    "rdoc/Guard/MarvFunctions.html",
    "rdoc/Guard/MarvTemplates.html",
    "rdoc/Marv.html",
    "rdoc/Marv/Builder.html",
    "rdoc/Marv/CLI.html",
    "rdoc/Marv/Error.html",
    "rdoc/Marv/Generator.html",
    "rdoc/Marv/Guard.html",
    "rdoc/Marv/LinkSourceDirNotFound.html",
    "rdoc/Marv/Project.html",
    "rdoc/Marv/Server.html",
    "rdoc/README_md.html",
    "rdoc/Tilt.html",
    "rdoc/Tilt/LessTemplateWithPaths.html",
    "rdoc/created.rid",
    "rdoc/fonts.css",
    "rdoc/fonts/Lato-Light.ttf",
    "rdoc/fonts/Lato-LightItalic.ttf",
    "rdoc/fonts/Lato-Regular.ttf",
    "rdoc/fonts/Lato-RegularItalic.ttf",
    "rdoc/fonts/SourceCodePro-Bold.ttf",
    "rdoc/fonts/SourceCodePro-Regular.ttf",
    "rdoc/images/add.png",
    "rdoc/images/arrow_up.png",
    "rdoc/images/brick.png",
    "rdoc/images/brick_link.png",
    "rdoc/images/bug.png",
    "rdoc/images/bullet_black.png",
    "rdoc/images/bullet_toggle_minus.png",
    "rdoc/images/bullet_toggle_plus.png",
    "rdoc/images/date.png",
    "rdoc/images/delete.png",
    "rdoc/images/find.png",
    "rdoc/images/loadingAnimation.gif",
    "rdoc/images/macFFBgHack.png",
    "rdoc/images/package.png",
    "rdoc/images/page_green.png",
    "rdoc/images/page_white_text.png",
    "rdoc/images/page_white_width.png",
    "rdoc/images/plugin.png",
    "rdoc/images/ruby.png",
    "rdoc/images/tag_blue.png",
    "rdoc/images/tag_green.png",
    "rdoc/images/transparent.png",
    "rdoc/images/wrench.png",
    "rdoc/images/wrench_orange.png",
    "rdoc/images/zoom.png",
    "rdoc/index.html",
    "rdoc/js/darkfish.js",
    "rdoc/js/jquery.js",
    "rdoc/js/navigation.js",
    "rdoc/js/search.js",
    "rdoc/js/search_index.js",
    "rdoc/js/searcher.js",
    "rdoc/rdoc.css",
    "rdoc/table_of_contents.html",
    "spec/lib/marv/project_spec.rb",
    "spec/spec_helper.rb"
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
      s.add_runtime_dependency(%q<rubyzip>, [">= 1.1.6"])
      s.add_runtime_dependency(%q<childprocess>, [">= 0.3.5"])
      s.add_runtime_dependency(%q<mysql2>, [">= 0.3.15"])
      s.add_runtime_dependency(%q<sass>, [">= 3.3.0"])
      s.add_runtime_dependency(%q<less>, [">= 2.6.0"])
      s.add_runtime_dependency(%q<coffee-script>, [">= 2.3.0"])
      s.add_runtime_dependency(%q<therubyracer>, [">= 0.12.0"])
      s.add_runtime_dependency(%q<uglifier>, [">= 2.5.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<aruba>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<thor>, [">= 0.19.1"])
      s.add_dependency(%q<guard-livereload>, [">= 2.3.0"])
      s.add_dependency(%q<sprockets>, [">= 2.12.0"])
      s.add_dependency(%q<rubyzip>, [">= 1.1.6"])
      s.add_dependency(%q<childprocess>, [">= 0.3.5"])
      s.add_dependency(%q<mysql2>, [">= 0.3.15"])
      s.add_dependency(%q<sass>, [">= 3.3.0"])
      s.add_dependency(%q<less>, [">= 2.6.0"])
      s.add_dependency(%q<coffee-script>, [">= 2.3.0"])
      s.add_dependency(%q<therubyracer>, [">= 0.12.0"])
      s.add_dependency(%q<uglifier>, [">= 2.5.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<aruba>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<thor>, [">= 0.19.1"])
    s.add_dependency(%q<guard-livereload>, [">= 2.3.0"])
    s.add_dependency(%q<sprockets>, [">= 2.12.0"])
    s.add_dependency(%q<rubyzip>, [">= 1.1.6"])
    s.add_dependency(%q<childprocess>, [">= 0.3.5"])
    s.add_dependency(%q<mysql2>, [">= 0.3.15"])
    s.add_dependency(%q<sass>, [">= 3.3.0"])
    s.add_dependency(%q<less>, [">= 2.6.0"])
    s.add_dependency(%q<coffee-script>, [">= 2.3.0"])
    s.add_dependency(%q<therubyracer>, [">= 0.12.0"])
    s.add_dependency(%q<uglifier>, [">= 2.5.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<aruba>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

