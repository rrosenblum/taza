# frozen_string_literal: true

require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)

task default: %i[spec rubocop]

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop)
