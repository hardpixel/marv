## What is Marv?

Marv is a free command-line toolkit for bootstrapping and developing WordPress themes in a tidy environment using front-end languages like Sass, LESS, and CoffeeScript.

[![Gem Version](https://badge.fury.io/rb/marv.svg)](http://badge.fury.io/rb/marv)


## How does it work?

Marv creates a neatly organized source folder with clean and simple scaffolding (base template files, SCSS files). The source folder is automatically compiled to your local WordPress install(s) as you save changes and work on your theme. When you are ready to distribute your theme Marv will build it to a folder of your choice or bundle the theme up into an easy to install zip package.


## Why use Marv?

Marv accelerates development by giving you access to higher-level languages like Sass, LESS, and CoffeeScript. These languages are much quicker and cleaner to code, but still compile to normal CSS and JavaScript. Marv also makes it easy to quickly bootstrap into and a more modular development environment, while still compiling "by the book" WordPress theme code.


## Basic setup

Install Marv (requires [Ruby](http://www.ruby-lang.org/) and [RubyGems](http://rubygems.org/)):

    $ gem install marv

Create your new theme project:

    $ marv create themename

Link to your WordPress theme folder:

    $ marv link /wordpress/wp-content/themes/my-theme

Watch for changes and start developing!

    $ cd themename
    $ marv watch

	Press Ctrl + Z to exit watch mode

Build your theme into the build_here directory:

    $ marv build build_here

Package your theme as themename.zip:

    $ marv package themename


## Help

Get a little help with the Marv commands:

    $ marv help


See the user's manual for more information.


## Credits

Marv is based on Forge by ThemeFoundry [Forge](https://github.com/thethemefoundry/forge)
Base Wordpress theme template is based on WP-Scaffold by Gizburdt [WP-Scaffold](https://github.com/gizburdt/wp-scaffold)