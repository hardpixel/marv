
require 'marv/project'

describe Marv::Project do
  before(:each) do
    @project = Marv::Project.new('/tmp/', nil, {:name => 'Hello'})
  end

  describe :config_file do
    it "should create an expanded path to the config file" do
      @project.config_file.should == '/tmp/config.rb'
    end
  end

  describe :assets_path do
    it "should create an expanded path to the assets folder" do
      @project.assets_path.should == '/tmp/assets'
    end
  end


  describe :build_dir do
    it "should create an expanded path to the marv build directory" do
      @project.build_dir.should == '/tmp/.watch'
    end
  end

  describe :theme_id do
    it "should be the same as the project folder" do
      @project.theme_id.should == 'tmp'
    end
  end

end
