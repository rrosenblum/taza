require 'thor'
require 'active_support/all'

module Taza
  class ProjectGenerator < Thor::Group
    include Thor::Actions

    argument :site_name
    argument :driver, :default => 'watir-webdriver'
    argument :browser, :default => 'firefox'

    def self.source_root

    end

  end
end