# frozen_string_literal: true

module Taza
  class Browser
    # Create a browser instance depending on configuration.  Configuration should be read in via Taza::Settings.config.
    #
    # Example:
    #     browser = Taza::Browser.create(Taza::Settings.config)
    #
    def self.create(params = {})
      send("create_#{params[:driver]}".to_sym, params)
    end

    def self.browser_class(params)
      send("#{params[:driver]}_#{params[:browser]}".to_sym)
    end

    private

    def self.create_watir(params)
      method = "watir_#{params[:browser]}"
      raise BrowserUnsupportedError unless respond_to?(method)
      watir = send(method, params)
      watir
    end

    def self.create_watir_webdriver(params)
      require 'watir-webdriver'
      Watir::Browser.new(params[:browser])
    end

    def self.create_selenium(params)
      require 'selenium'
      Selenium::SeleniumDriver.new(params[:server_ip], params[:server_port], '*' + params[:browser].to_s, params[:timeout])
    end

    def self.create_selenium_webdriver(params)
      require 'selenium-webdriver'
      # Small hack. :)
      Selenium::WebDriver::Driver.class_eval do
        def goto(params)
          navigate.to params
        end
      end
      Selenium::WebDriver.for params[:browser].to_sym
    end

    def self.watir_firefox(_params)
      require 'firewatir'
      FireWatir::Firefox.new
    end

    def self.watir_safari(_params)
      require 'safariwatir'
      Watir::Safari.new
    end

    def self.watir_ie(params)
      require 'watir'
      browser = Watir::Browser.find(:title, //) if params[:attach]
      browser || Watir::Browser.new
    end
  end

  # We don't know how to create the browser you asked for
  class BrowserUnsupportedError < StandardError; end
end
