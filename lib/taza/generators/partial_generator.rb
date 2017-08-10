# frozen_string_literal: true

require 'thor'
require 'active_support/all'

module Taza
  class PartialGenerator < Thor::Group
    attr_reader :name
    include Thor::Actions

    argument :partial_name
    argument :site_name

    def self.source_root
      File.dirname(__FILE__)
    end

    desc 'This will generate your Taza partial. Example: taza partial navigation foo'
    def partial
      @name = site_name.underscore

      if File.directory?("lib/sites/#{name}")
        create_partial
      else
        say "No such site #{name} exists! ", :red
        say "Please run 'taza create #{name}'", :green
      end
    end

    private

    def create_partial
      template('templates/partial/partial.rb.tt', "lib/sites/#{name}/pages/partials/#{partial_name}.rb")
    end
  end
end
