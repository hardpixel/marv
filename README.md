## Marv is a toolkit for bootstrapping and developing WordPress themes.

-----

Current Version: **0.1.0**

Install Marv (requires [Ruby](http://www.ruby-lang.org/) and [RubyGems](http://rubygems.org/)):

    $ gem install marv

Create your new theme project:

    $ marv create your_theme

Change to your new project directory:

    $ cd your_theme

Link to your WordPress theme folder:

    $ marv link /path/to/wordpress/wp-content/themes/your_theme

Watch for changes and start developing!

    $ marv watch

Press Ctrl + Z to exit watch mode

Build your theme into the build_here directory:

    $ marv build build_here

Package your theme as your_theme.zip:

    $ marv package your_theme

Get a little help with the Marv commands:

    $ marv help

-----


If you have any problems using the gem, open a new issue and we'll help you sort it out!