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

  url = 'https://creativelab.jp/login'
  session = Capybara::Session.new(:selenium)
  session.visit url
  session.save_and_open_screenshot('screenshot.jpg')
end
