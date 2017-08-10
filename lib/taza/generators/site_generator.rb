# frozen_string_literal: true

require 'thor'
require 'active_support/all'

module Taza
  class SiteGenerator < Thor::Group
    include Thor::Actions

    argument :site_name

    def self.source_root
      File.dirname(__FILE__)
    end

    desc 'This will generate your Taza site. Example: taza site foo'
    def site
      name = site_name.underscore

      template('templates/site/site.yml.tt', "config/#{name}.yml")
      template('templates/site/site.rb.tt', "lib/sites/#{name}.rb")
      empty_directory "lib/sites/#{name}"
      empty_directory "lib/sites/#{name}/flows"
      empty_directory "lib/sites/#{name}/pages"
      empty_directory "lib/sites/#{name}/pages/partials"
    end
  end
end
