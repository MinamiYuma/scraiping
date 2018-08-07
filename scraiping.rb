require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'slim'

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

  url = 'http://abehiroshi.la.coocan.jp/movie/eiga.htm'
  session = Capybara::Session.new(:selenium)
  session.visit(url)

  @movies = session.find_all('table')[1]
            .find_all('tr').each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |title, result|
              result['titles'].push(title.text)
            end

  slim :index
end
