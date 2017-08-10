# frozen_string_literal: true

require 'thor'
require 'active_support/all'

module Taza
  class PageGenerator < Thor::Group
    include Thor::Actions

    argument :page_name
    argument :site_name

    def self.source_root
      File.dirname(__FILE__)
    end

    desc 'This will generate a Taza page for your site. Example: taza page home foo'
    def page
      name = site_name.underscore

      if File.directory?("lib/sites/#{name}")
        template('templates/page/page.rb.tt', "lib/sites/#{name}/pages/#{page_name}_page.rb")
        template('templates/page/page_spec.rb.tt', "spec/isolation/#{page_name}_page_spec.rb")
      else
        say "No such site #{name} exists! ", :red
        say "Please run 'taza create #{name}'", :green
      end
    end
  end
end
