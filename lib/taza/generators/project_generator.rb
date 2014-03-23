require 'thor'
require 'active_support/all'

module Taza
  class ProjectGenerator < Thor::Group
    include Thor::Actions

    argument :site_name
    argument :driver, :default => 'watir-webdriver'
    argument :browser, :default => 'firefox'

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "This creates the Taza project structure"
    def create
      template('templates/project/Gemfile.tt', 'Gemfile') unless File.exists? 'Gemfile'
    end

  end
end