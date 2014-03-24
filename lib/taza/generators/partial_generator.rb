require 'thor'
require 'active_support/all'

module Taza
  class PartialGenerator < Thor::Group
    include Thor::Actions

    argument :partial_name
    argument :site_name

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "This will generate your Taza partial. Example: taza partial navigation foo"
    def partial
      name = site_name.underscore

      if File.directory?("lib/sites/#{name}")
        template('templates/partial/partial.rb.tt', "lib/sites/#{name}/pages/partials/#{partial_name}.rb")
      else
        say "No such site #{name} exists! ", :red
        say "Please run 'taza create #{name}'", :green
      end
    end
  end
end
