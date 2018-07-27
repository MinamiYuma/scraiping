require 'sinatra'
require 'sinatra/reloader'
require 'pry'

require 'selenium-webdriver'
require 'capybara'

get '/' do
  Capybara.configure do |capybara_config|
    capybara_config.default_driver = :selenium
    capybara_config.default_max_wait_time = 10
  end

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        chrome_options: {
          args: %w(headless disable-gpu window-size=1680,1050),
        },
      )
    )
  end
  Capybara.javascript_driver = :chrome

  start_scraping 'https://creativelab.jp/login' do
    save_and_open_screenshot
  end
end

def start_scraping(url, &block)
  Capybara::Session.new(:selenium).tap { |session|
    session.visit url
    session.instance_eval(&block)
  }
end
