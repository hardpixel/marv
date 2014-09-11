require 'sprockets'
require 'sass'
require 'less'
require 'zip'
require 'marv/engines'

module Marv
  class Builder

    def initialize(project)
      @project = project
      @task = project.task
      @templates_path = @project.templates_path
      @assets_path = @project.assets_path
      @functions_path = @project.functions_path
      @includes_path = @project.includes_path
      @package_path = @project.package_path

      init_sprockets
    end

    # Runs all the methods necessary to build a completed project
    def build
      clean_build_directory
      copy_templates
      copy_functions
      copy_includes
      copy_folders
      build_assets
    end

    # Use the rubyzip library to build a zip from the generated source
    def zip(filename=nil)
      filename = filename || File.basename(@project.root)
      project_base = File.basename(@project.root)

      zip_filename = File.join(File.basename(@package_path), "#{filename}.zip")
      # Create a temporary file for RubyZip to write to
      temp_filename = "#{zip_filename}.tmp"

      File.delete(temp_filename) if File.exists?(temp_filename)

      # Wrapping the zip creation in Thor's create_file to get "overwrite" prompts
      # Note: I could be overcomplicating this
      @task.create_file(zip_filename) do
        Zip::File.open(temp_filename, Zip::File::CREATE) do |zip|
          # Get all filenames in the build directory recursively
          filenames = Dir[File.join(@project.build_path, '**', '*')]

          # Remove the build directory path from the filename
          filenames.collect! {|path| path.gsub(/#{@project.build_path}\//, '')}

          # Add each file in the build directory to the zip file
          filenames.each do |filename|
            zip.add File.join(project_base, filename), File.join(@project.build_path, filename)
          end
        end

        # Give Thor contents of zip file for "overwrite" prompt
        File.open(temp_filename, 'rb') { |f| f.read }
      end

      # Clean up the temp file
      File.delete(temp_filename)
    end

    # Empty out the build directory
    def clean_build_directory
      # create build path if it does not exist
      unless File.exists?(@project.build_path)
        FileUtils.mkdir_p(@project.build_path)
      end
      # Empty the build path
      FileUtils.rm_rf Dir.glob(File.join(@project.build_path, '*'))
    end

    def clean_templates
      # TODO: cleaner way of removing templates only?
      Dir.glob(File.join(@project.build_path, '*.php')).each do |path|
        FileUtils.rm path unless path.include?('functions.php')
      end
    end

    def copy_templates(clean=nil)
      unless clean.nil?
        clean_templates
      end

      template_paths.each do |template_path|
        # Skip directories
        next if File.directory?(template_path)

        if template_path.end_with?('.erb')
          # Chop the .erb extension off the filename
          destination = File.join(@project.build_path, File.basename(template_path).slice(0..-5))

          write_erb(template_path, destination)
        else
          # Regular old copy of PHP-only files
          FileUtils.cp template_path, @project.build_path
        end
      end
    end

    def clean_functions
      #remove functions php
      if File.exists?(File.join(@project.build_path, 'functions.php'))
        FileUtils.rm File.join(@project.build_path, 'functions.php')
      end
      # Remove plugin file
      if File.exists?(@project.project_php_file)
        FileUtils.rm File.join(@project.build_path, @project.project_php_file)
      end
      # Remove functions folder
      if File.directory?(File.join(@project.build_path, 'functions'))
        FileUtils.rm_rf File.join(@project.build_path, 'functions')
      end
    end

    def copy_functions(clean=nil)
      # Clean functions
      unless clean.nil?
        clean_functions
      end

      # Copy functions
      functions_erb_path = File.join(@functions_path, 'functions.php.erb')
      functions_php_path = File.join(@functions_path, 'functions.php')
      plugin_php_path = File.join(@functions_path, @project.project_php_file)

      if File.exists?(functions_erb_path)
        destination = File.join(@project.build_path, 'functions.php')
        write_erb(functions_erb_path, destination)
      elsif File.exists?(functions_php_path)
        FileUtils.cp functions_php_path, @project.build_path
      end

      if File.exists?(plugin_php_path)
        FileUtils.cp plugin_php_path, @project.build_path
      end

      functions_paths = Dir.glob(File.join(@functions_path, '*')).reject do |filename|
        [functions_erb_path, functions_php_path, plugin_php_path].include?(filename)
      end

      unless functions_paths.empty?
        # Create the functions folder in the build directory
        unless File.directory?(File.join(@project.build_path, 'functions'))
          FileUtils.mkdir_p(File.join(@project.build_path, 'functions'))
        end

        # Iterate over all files in source/functions, skipping the actual functions.php file
        paths = Dir.glob(File.join(@functions_path, '**', '*')).reject do |filename|
          [functions_erb_path, functions_php_path, plugin_php_path].include?(filename)
        end

        copy_paths_with_erb(paths, @functions_path, File.join(@project.build_path, 'functions'))
      end
    end

    def clean_includes
      FileUtils.rm_rf File.join(@project.build_path, 'includes')
    end

    def copy_includes(clean=nil)
      # Clean Includes
      unless clean.nil?
        clean_includes
      end

      # Copy includes
      unless Dir.glob(File.join(@includes_path, '*')).empty?
        # Create the includes folder in the build directory
        unless File.directory?(File.join(@project.build_path, 'includes'))
          FileUtils.mkdir(File.join(@project.build_path, 'includes'))
        end

        # Iterate over all files in source/includes, so we can exclude if necessary
        paths = Dir.glob(File.join(@includes_path, '**', '*'))
        copy_paths_with_erb(paths, @includes_path, File.join(@project.build_path, 'includes'))
      end
    end

    def clean_folders(folder)
      # Clean folder
      relative_path = folder.gsub(@project.source_path, '')
      destination = File.join(@project.build_path, relative_path)

      FileUtils.rm_rf destination
    end

    def copy_folders(clean=nil)
      folders = Dir.glob(File.join(@project.source_path, '*'))

      folders.each do |folder|
        if File.directory?(folder)
          unless [@assets_path, @templates_path, @functions_path, @includes_path].include?(folder)
            # Clean folders
            unless clean.nil?
              clean_folders(folder)
            end
            # Copy folders
            paths = Dir.glob(File.join(folder, '**', '*'))
            copy_paths_with_erb(paths, @project.source_path, @project.build_path)
          end
        end
      end
    end

    def clean_images
      FileUtils.rm_rf File.join(@project.build_path, 'images')
    end

    def build_assets(clean=nil)
      # Clean images
      unless clean.nil?
        clean_images
      end

      # Build assets
      default_assets = [['style.css'], ['admin.css'], ['javascripts', 'theme.js'], ['javascripts', 'admin.js']]
      additional_assets = @project.config[:additional_assets]

      if additional_assets
        assets = default_assets + additional_assets
      else
        assets = default_assets
      end

      assets.each do |asset|
        destination = File.join(@project.build_path, asset)

        # Catch any sprockets errors and continue the process
        begin
          @task.shell.mute do
            sprocket = @sprockets.find_asset(asset.last)

            FileUtils.mkdir_p(File.dirname(destination)) unless File.directory?(File.dirname(destination))
            sprocket.write_to(destination) unless sprocket.nil?
          end
        rescue Exception => e
          @task.say "Error while building #{asset.last}:"
          @task.say e.message, :red

          File.open(destination, 'w') do |file|
            file.puts(e.message)
          end

          # Re-initializing sprockets to prevent further errors
          # TODO: This is done for lack of a better solution
          init_sprockets
        end
      end

      # Copy the images directory over
      if File.directory?(File.join(@assets_path, 'images'))
        FileUtils.cp_r(File.join(@assets_path, 'images'), @project.build_path)
      end

      # Check for screenshot and move it into main build directory
      Dir.glob(File.join(@project.build_path, 'images', '*')).each do |filename|
        if filename.index(/screenshot\.(png|jpg|jpeg|gif)/)
          FileUtils.mv(filename, @project.build_path + File::SEPARATOR )
        end
      end
    end

    private

    def copy_paths_with_erb(paths, source_dir, destination_dir)
      paths.each do |path|
        # Remove source directory from full file path to get the relative path
        relative_path = path.gsub(source_dir, '')

        destination = File.join(destination_dir, relative_path)

        if destination.end_with?('.erb')
          # Remove the .erb extension if the path was an erb file
          destination = destination.slice(0..-5)
          # And process it as an erb
          write_erb(path, destination)
        else
          # Otherwise, we simply move the file over
          FileUtils.mkdir_p(destination) if File.directory?(path)
          FileUtils.cp path, destination unless File.directory?(path)
        end
      end
    end

    def init_sprockets
      @sprockets = Sprockets::Environment.new

      ['javascripts', 'stylesheets'].each do |dir|
        @sprockets.append_path File.join(@assets_path, dir)
      end

      if @project.config[:compress_js]
        @sprockets.js_compressor = :uglify
      end

      if @project.config[:compress_css]
        @sprockets.css_compressor = :scss
      end

      # Add assets/styleshets to load path for Less Engine
      Tilt::LessTemplateWithPaths.load_path = File.join(@assets_path, 'stylesheets')

      @sprockets.register_engine '.less', Tilt::LessTemplateWithPaths

      # Passing the @project instance variable to the Sprockets::Context instance
      # used for processing the asset ERB files. Ruby meta-programming, FTW.
      @sprockets.context_class.instance_exec(@project) do |project|
        define_method :config do
          project.config
        end
      end
    end

    def template_paths
      Dir.glob(File.join(@templates_path, '**', '*'))
    end

    # Generate a unique filename for the zip output
    def get_output_filename(basename)
      package_path_base = File.basename(@package_path)
      filename = File.join(package_path_base, "#{basename}.zip")

      i = 1
      while File.exists?(filename)
        filename = File.join(package_path_base, "#{basename}(#{i}).zip")
        i += 1
      end

      filename
    end

    protected

    # Write an .erb from source to destination, catching and reporting errors along the way
    def write_erb(source, destination)
      begin
        @task.shell.mute do
          @task.create_file(destination) do
            @project.parse_erb(source)
          end
        end
      rescue Exception => e
        @task.say "Error while building #{File.basename(source)}:"
        @task.say e.message + "\n", :red
        exit
      end
    end

  end
end