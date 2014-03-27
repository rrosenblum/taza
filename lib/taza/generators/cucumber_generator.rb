require 'thor'
require 'active_support/all'

module Taza
  class CucumberGenerator < Thor::Group
    include Thor::Actions

    argument :site_name

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "This will setup cucumber for your Taza site. Example: taza cucumber foo"
    def cucumber
      name = site_name.underscore

      if File.directory?("lib/sites/#{name}")
      template('templates/cucumber/example.feature.tt', "features/example.feature")
      template('templates/cucumber/env.rb.tt', "features/support/env.rb")
      template('templates/cucumber/hooks.rb.tt', "features/support/hooks.rb")
      template('templates/cucumber/example_steps.rb.tt', "features/step_definitions/example_steps.rb")

      empty_directory "features"
      empty_directory "features/support"
      empty_directory "features/step_definitions"

      else
        say "No such site #{name} exists! ", :red
        say "Please run 'taza site #{name}'", :green
      end


    end
  end
end