require 'thor'
require 'taza/version'

require_relative 'flow_generator'
require_relative 'partial_generator'
require_relative 'page_generator'
require_relative 'site_generator'
require_relative 'project_generator'
require_relative 'cucumber_generator'

module Taza
  class TazaGenerators < Thor

    register(Taza::ProjectGenerator, 'create', "create SITE_NAME", 'This creates the Taza structure. Example: taza create foo')
    register(Taza::SiteGenerator, 'site', 'site SITE_NAME', 'This will generate your Taza site. Example: taza site foo')
    register(Taza::PageGenerator, 'page', 'page PAGE_NAME SITE_NAME', 'This will generate your Taza page. Example: taza page checkout foo')
    register(Taza::PartialGenerator, 'partial', 'partial PARTIAL_NAME SITE_NAME', 'This will generate your Taza partial. Example: taza partial navigation foo')
    register(Taza::FlowGenerator, 'flow', 'flow FLOW_NAME SITE_NAME', 'This will generate your Taza flow. Example: taza flow checkout foo')
    register(Taza::CucumberGenerator, 'cucumber', 'cucumber SITE_NAME', 'This will setup cucumber for your Taza site. Example: taza cucumber foo')
  end
end