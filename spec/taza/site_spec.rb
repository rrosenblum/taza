# frozen_string_literal: true

require 'spec_helper'
require 'rubygems'
require 'taza/site'
require 'taza/settings'
require 'taza/options'
require 'taza/browser'
require 'taza/page'
require 'taza/flow'

describe Taza::Site do
  before(:all) do
    Foo = Class.new(Taza::Site)
  end
  # TODO: we need to clean up these tests and remove the warning below
  # /Users/bisbot/Projects/Taza/taza/spec/taza/site_spec.rb:15: warning: already initialized constant Foo
  before :each do
    @pages_path = File.join(@original_directory, 'spec', 'sandbox', 'pages', 'foo', '**', '*.rb')
    @flows_path = File.join(@original_directory, 'spec', 'sandbox', 'flows', '*.rb')
    Foo.any_instance.stubs(:pages_path).returns(@pages_path)
    ENV['BROWSER'] = nil
    ENV['DRIVER'] = nil
    Taza::Settings.stubs(:config_file).returns({})
    Taza::Settings.stubs(:site_file).returns({})
    Taza::Site.before_browser_closes {}
  end

  it 'pages_path should contain the site class name' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    Bax = Class.new(Taza::Site)
    expect(Bax.new.pages_path).to eql './lib/sites/bax/pages/**/*.rb'
  end

  it 'should have flows defined as instance methods' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    Barz = Class.new(Taza::Site)
    Barz.any_instance.stubs(:path).returns("#{@original_directory}/spec/sandbox/")
    Barz.any_instance.stubs(:flows_path).returns("#{@original_directory}/spec/sandbox/flows/batman.rb")
    expect(Barz.new.batman_flow).to eql 'i am batman'
  end

  it 'should open watir browsers at the configuration URL' do
    browser = stub_browser
    browser.expects(:goto).with('a_url')
    Taza::Browser.stubs(:create).returns(browser)
    Taza::Settings.stubs(:config).returns(url: 'a_url')
    Foo.new
  end

  it 'should yield an instance of a page class' do
    f = Foo.new(browser: stub_browser)
    barzor = nil
    f.bar do |bar|
      barzor = bar
    end
    expect(barzor).to be_an_instance_of Bar
  end

  it 'should accept a browser instance' do
    browser = stub_browser
    foo = Foo.new(browser: browser)
    expect(foo.browser).to eql browser
  end

  it 'should create a browser instance if one is not provided' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    foo = Foo.new
    expect(foo.browser).to eql browser
  end

  it 'should still close browser if an error is raised' do
    browser = stub_browser
    browser.expects(:close)
    Taza::Browser.stubs(:create).returns(browser)
    expect(-> { Foo.new { |_site| raise StandardError } }).to raise_error(StandardError)
  end

  it 'should not close browser if block not given' do
    browser = stub
    browser.stubs(:goto)
    browser.expects(:close).never
    Taza::Browser.stubs(:create).returns(browser)
    Foo.new
  end

  it 'should not close browser if an error is raised on browser goto' do
    browser = Object.new
    browser.stubs(:goto).raises(StandardError, 'ErrorOnBrowserGoto')
    browser.expects(:close).never
    Taza::Browser.stubs(:create).returns(browser)
    expect(-> { Foo.new }).to raise_error(StandardError, 'ErrorOnBrowserGoto')
  end

  it 'should raise browser close error if no other errors' do
    browser = stub_browser
    browser.expects(:close).raises(StandardError, 'BrowserCloseError')
    Taza::Browser.stubs(:create).returns(browser)
    expect(-> { Foo.new {} }).to raise_error(StandardError, 'BrowserCloseError')
  end

  it 'should raise error inside block if both it and browser.close throws an error' do
    browser = stub_browser
    browser.expects(:close).raises(StandardError, 'BrowserCloseError')
    Taza::Browser.stubs(:create).returns(browser)
    expect(-> { Foo.new { |_site| raise StandardError, 'innererror' } }).to raise_error(StandardError, 'innererror')
  end

  it 'should close a browser if block given' do
    browser = stub_browser
    browser.expects(:close)
    Taza::Browser.stubs(:create).returns(browser)
    Foo.new do |site|
    end
  end

  it 'should yield itself upon initialization' do
    Taza::Browser.stubs(:create).returns(stub_browser)
    foo = nil
    f = Foo.new do |site|
      foo = site
    end
    expect(foo).to eql f
  end

  it 'should yield after page methods have been setup' do
    Taza::Browser.stubs(:create).returns(stub_browser)
    klass = Class.new(Taza::Site)
    klass.any_instance.stubs(:pages_path).returns(@pages_path)
    klass.new do |site|
      expect(site).to respond_to :bar
    end
  end

  it 'should yield after browser has been setup' do
    Taza::Browser.stubs(:create).returns(stub_browser)
    klass = Class.new(Taza::Site)
    klass.any_instance.stubs(:pages_path).returns(@pages_path)
    klass.new do |site|
      expect(site.browser).to_not be_nil
    end
  end

  it 'should pass its browser instance to its pages ' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    foo = Foo.new
    expect(foo.bar.browser).to eql browser
  end

  it 'should add partials defined under the pages directory' do
    Taza::Browser.stubs(:create).returns(stub_browser)
    klass = Class.new(Taza::Site)
    klass.any_instance.stubs(:pages_path).returns(@pages_path)
    klass.new(&:partial_the_reckoning)
  end

  it 'should have a way to evaluate a block of code before site closes the browser' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    browser_state = states('browser_open_state').starts_as('on')
    browser.expects(:close).then(browser_state.is('off'))
    browser.expects(:doit).when(browser_state.is('on'))
    Taza::Site.before_browser_closes(&:doit)
    Foo.new {}
  end

  it 'should have a way to evaluate a block of code before site closes the browser if an error occurs' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    browser_state = states('browser_open_state').starts_as('on')
    browser.expects(:close).then(browser_state.is('off'))
    browser.expects(:doit).when(browser_state.is('on'))
    Taza::Site.before_browser_closes(&:doit)
    expect(-> { Foo.new { |_site| raise StandardError, 'innererror' } }).to raise_error(StandardError, 'innererror')
  end

  it 'should still close its browser if #before_browser_closes raises an exception' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    browser.expects(:close)
    Taza::Site.before_browser_closes { |_browser| raise StandardError, 'foo error' }
    expect(-> { Foo.new {} }).to raise_error(StandardError, 'foo error')
  end

  it 'should not close a browser it did not make' do
    browser = stub_browser
    browser.expects(:close).never
    Foo.new(browser: browser) {}
  end

  it 'should close a browser it did make' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    browser.expects(:close)
    Foo.new {}
  end

  module Zoro
    class Zoro < ::Taza::Site
    end
  end

  it 'should pass in the class name to settings config' do
    browser = stub_browser
    Taza::Browser.stubs(:create).returns(browser)
    Taza::Settings.expects(:config).with('Zoro').returns({})
    Zoro::Zoro.new
  end

  it 'should load settings based on the sites class name' do
    Taza::Settings.expects(:site_file).with('Zoro').returns({})
    Zoro::Zoro.settings
  end

  def stub_browser
    browser = stub
    browser.stubs(:close)
    browser.stubs(:goto)
    browser
  end

  it 'should yield an instance of page class that can access page-module specific elements' do
    f = Foo.new(browser: stub_browser)
    barzor = nil
    f.baz(:module) do |baz|
      barzor = baz
    end
    expect(barzor).to be_an_instance_of Baz
    expect(barzor.some_element).to eql :some_element_value
  end

  it 'should raise an error when accessing an element that belongs to another module' do
    f = Foo.new(browser: stub_browser)
    barzor = nil
    f.baz(:another_module) do |baz|
      barzor = baz
    end
    expect(-> { barzor.other_element }).to raise_error(NoMethodError)
  end

  it 'should have a way to keep the browser instance open' do
    browser = stub_browser
    browser.expects(:close).never
    Taza::Browser.stubs(:create).returns(browser)
    Taza::Site.donot_close_browser
    Foo.new {}
  end

  it 'should have a way to keep the browser instance open if an error is raised' do
    browser = stub_browser
    browser.expects(:close).never
    Taza::Browser.stubs(:create).returns(browser)
    Taza::Site.donot_close_browser
    expect(-> { Foo.new { |_site| raise StandardError } }).to raise_error(StandardError)
  end
end
