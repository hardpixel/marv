## What is Marv?

Marv is a free command-line toolkit for bootstrapping and developing WordPress themes and plugins in a tidy environment using front-end languages like Sass, LESS, and CoffeeScript.

[![Gem Version](https://badge.fury.io/rb/marv.png)](http://badge.fury.io/rb/marv)
[![Code Climate](https://codeclimate.com/github/hardpixel/marv/badges/gpa.png)](https://codeclimate.com/github/hardpixel/marv)


## How does it work?

Marv creates a neatly organized source folder with clean and simple scaffolding (base template files, SCSS files). The source folder is automatically compiled to your development server(s) as you save changes and work on your project. When you are ready to distribute your project Marv will build it to a folder of your choice or bundle the project up into an easy to install zip package.


## Why use Marv?

Marv accelerates development by giving you access to higher-level languages like Sass, LESS, and CoffeeScript. These languages are much quicker and cleaner to code, but still compile to normal CSS and JavaScript. Marv also makes it easy to quickly bootstrap into and a more modular development environment, while still compiling "by the book" WordPress code.


## Basic setup

Install Marv (requires [Ruby](http://www.ruby-lang.org/) and [RubyGems](http://rubygems.org/)):

    $ gem install marv

Create your new project:

    $ marv create project-name

Create your development server:

	$ marv server create server-name

Link to your development server:

	$ cd project-name
    $ marv link server-name

Also you can link to a WordPress installation:

	$ cd project-name
    $ marv link /var/www/wordpress

Watch for changes and start developing!

    $ cd project-name
    $ marv watch

	Press Ctrl + D to exit watch mode

Build your project into the build_here directory:

    $ marv build build_here

Package your project as package-name.zip:

    $ marv package package-name


## Help

Get a little help with the Marv commands:

    $ marv help
    $ marv help command


See the [user's manual](https://github.com/hardpixel/marv/wiki) for more information.


## Credits

Wordpress theme layout is based on [WP-Scaffold](https://github.com/gizburdt/wp-scaffold) by Gizburdt.

Marv is inspired from [Forge](https://github.com/thethemefoundry/forge) by ThemeFoundry.
