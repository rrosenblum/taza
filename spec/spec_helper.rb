#require 'rubygems'
#require 'bundler/setup'
#require 'mocha'
require 'taza'
require 'thor'
require 'watir'

RSpec.configure do |config|
  config.mock_with :mocha

  config.before(:each) do
    $0 = 'home'
    ARGV.clear
    @directory = Dir.mktmpdir('taza-sandbox-')
    @original_directory = Dir.pwd
    Dir.chdir(@directory)
  end

  config.after(:each) do
    Dir.chdir(@original_directory)
    FileUtils.rmtree(@directory)
  end

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end
end

def null_device
  File.exists?('/dev/null') ? '/dev/null' : 'NUL'
end

# Must set before requiring generator libs.
TMP_ROOT = File.join(File.dirname(__FILE__),"sandbox","generated")
PROJECT_NAME = 'example'
PROJECT_FOLDER = File.join(TMP_ROOT,PROJECT_NAME)
APP_ROOT = File.join(TMP_ROOT, PROJECT_NAME)

def generator_sources
  [RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..","lib", "app_generators")),
  RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", "generators"))]
end

module Helpers
  module Generator
    def generate_site(site_name)
      site_name = "#{site_name}#{Time.now.to_i}"
      run_generator('site', [site_name], generator_sources)
      site_file_path = File.join(PROJECT_FOLDER,'lib','sites',"#{site_name.underscore}.rb")
      require site_file_path
      "::#{site_name.camelize}::#{site_name.camelize}".constantize.any_instance.stubs(:base_path).returns(PROJECT_FOLDER)
      site_name.camelize.constantize
    end
  end

  module Taza
    def stub_settings
      ::Taza::Settings.stubs(:config).returns({})
    end

    def stub_browser
      stub_browser = stub
      stub_browser.stubs(:goto)
      stub_browser.stubs(:close)
      ::Taza::Browser.stubs(:create).returns(stub_browser)
    end
  end
end
#### Rubigen helpers end
