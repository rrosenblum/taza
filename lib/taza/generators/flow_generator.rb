require 'thor'
require 'active_support/all'

module Taza
  class FlowGenerator < Thor::Group
    include Thor::Actions

    argument :flow_name
    argument :site_name

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "This will generate your Taza flow. Example: taza flow checkout foo"
    def flow
      name = site_name.underscore

      if File.directory?("lib/sites/#{name}")
        template('templates/flow/flow.rb.tt', "lib/sites/#{name}/flows/#{flow_name}.rb")
      else
        say "No such site #{name} exists! ", :red
        say "Please run 'taza create #{name}'", :green
      end

    end
  end
end
