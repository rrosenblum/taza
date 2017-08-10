# frozen_string_literal: true

require 'rspec'

class FailingExamplesFormatter < RSpec::Core::Formatters::DocumentationFormatter
  def example_passed(example); end
end
