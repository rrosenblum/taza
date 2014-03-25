require 'thor'
require 'active_support/all'

module Taza
  class FlowGenerator < PartialGenerator

    desc "This will generate your Taza flow. Example: taza flow checkout foo"
    def flow
      partial
    end

    private
    def create_partial
      template('templates/flow/flow.rb.tt', "lib/sites/#{name}/flows/#{partial_name}.rb")
    end
  end
end
