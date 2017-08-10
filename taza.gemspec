# -*- encoding: utf-8 -*-
# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'taza/version'

Gem::Specification.new do |s|
  s.name                  = 'taza'
  s.version               = Taza::VERSION
  s.platform              = Gem::Platform::RUBY
  s.authors               = ['Adam Anderson', 'Pedro Nascimento', 'Oscar Rieken']
  s.email                 = ['watir-general@googlegroups.com']
  s.homepage              = 'http://github.com/hammernight/taza'
  s.summary               = 'Taza is an opinionated page object framework.'
  s.description           = 'Taza is an opinionated page object framework.'
  s.required_ruby_version = '>= 2.0.0'
  s.rubyforge_project     = 'taza'
  s.files                 = `git ls-files`.split("\n")
  s.test_files            = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables           = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths         = ['lib']

  s.add_runtime_dependency('rake', '>= 0.9.2')
  s.add_runtime_dependency('mocha', '>= 0.9.3')
  s.add_runtime_dependency('user-choices', '~> 1.1.6.1')
  s.add_runtime_dependency('Selenium', '~> 1.1.14')
  s.add_runtime_dependency('firewatir', '~> 1.9.4')
  s.add_runtime_dependency('watir-webdriver', '~> 0.4')
  s.add_runtime_dependency('watir', '>= 5.0.0')
  s.add_runtime_dependency('activesupport', '>= 3.2.0')
  s.add_runtime_dependency('thor', '>= 0.18.1')
  s.add_runtime_dependency('rspec', '~> 3.0')

  s.add_development_dependency('rubocop', '~> 0.49.0')
end
