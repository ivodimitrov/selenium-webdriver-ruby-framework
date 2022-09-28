$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'allure-rspec'
require 'data_magic'
require 'headless'
require 'page-object'
require 'parallel_tests'
require 'pry'
require 'require_all'
require 'rspec'
require 'watir'
require 'webdrivers'

require_all 'lib'
require_all 'support'

BASE_URL = Base.build_url ''
BROWSER_NAME = ENV.fetch 'BROWSER', 'chrome'
CONFIGURATION = ENV.fetch 'CONFIG', 'default'
WINDOW_SIZE = ENV.fetch 'WINDOW_SIZE', false
TEST_ENV_NUMBER = ENV.fetch 'TEST_ENV_NUMBER', false

Allure.configure do |config|
  config.results_directory = 'results/allure-results'
  config.clean_results_directory = true
  config.logging_level = Logger::INFO
  config.link_tms_pattern = 'https://testrail.net/index.php?/cases/view/{}'
end

Selenium::WebDriver.logger.output = 'selenium.log'
# Watir.logger.selenium = :info
# Watir.logger.level = :debug

RSpec.configure do |config|
  config.include PageObject::PageFactory

  config.formatter = AllureRspecFormatter

  config.before :all do
    @data = DataMagic.load "#{CONFIGURATION}.yml"

    case BROWSER_NAME.upcase
    when 'CHROME'
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_preference :download, directory_upgrade: true, prompt_for_download: false, default_directory: 'tmp/'
      options.add_preference :browser, set_download_behavior: { behavior: 'allow' }
      @browser = Watir::Browser.new :chrome, options: options
    when 'CHROME_HEADLESS'
      @browser = Watir::Browser.new :chrome, headless: true
    when 'FIREFOX'
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.dir'] = '/tmp/webdriver-downloads'
      profile['browser.download.folderList'] = 2
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf;text/csv'
      profile['pdfjs.disabled'] = true
      profile['csvjs.disabled'] = true
      @browser = Watir::Browser.new :firefox, options: { profile: profile }
    when 'FIREFOX_HEADLESS'
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf;text/csv'
      profile['pdfjs.disabled'] = true
      profile['csvjs.disabled'] = true
      @browser = Watir::Browser.new :firefox, headless: true, options: { profile: profile }
    when 'SAFARI'
      @browser = Watir::Browser.new :safari, technology_preview: false
    else
      raise ArgumentError, "Browser: #{BROWSER_NAME} is not supported! Please use: Chrome, Chrome_headless, Firefox,
                          Firefox_headless or Safari!"
    end

    # Resizes window to given width and height. Smallest window size that framework support is: 1280x740 !
    # Please use WINDOW_SIZE=1280x740 or WINDOW_SIZE=1280*740 !
    if WINDOW_SIZE && BROWSER_NAME.upcase != 'SAFARI'
      @browser.window.resize_to WINDOW_SIZE.to_s.split(/[*x]/)[0], WINDOW_SIZE.to_s.split(/[*x]/)[1]
    elsif BROWSER_NAME.upcase.include? 'HEADLESS'
      @browser.window.resize_to 1280, 740
    else
      @browser.window.maximize
    end

    puts # adds empty line for easier reading of console log

    unless ENV['CI_BROWSER']
      puts "#{BROWSER_NAME.gsub('_', ' ').capitalize} browser started..."
      puts "Browser version is: #{@browser.driver.capabilities[:browser_version]}"
    end

    puts "Window size is: #{@browser.window.size.width}x#{@browser.window.size.height}" # Returns window size.
    puts # adds empty line for easier reading of console log
  end

  config.before :all do
    %i(all bank costs_sales expense_reports integrations regression smoke subscriptions test).each do |scope|
      @scope = scope if self.class.metadata.key? scope
    end
  end

  config.before do |example|
    Allure.step name: example.metadata[:full_description]
    Allure.add_attachment(
      name: 'Before example',
      source: @browser.screenshot.png,
      type: Allure::ContentType::PNG,
      test_case: true
    )
  end

  if ENV['TEST_ENV_NUMBER']
    config.around do |example|
      puts "    Running #{example.full_description} in parallel thread: #{ENV['TEST_ENV_NUMBER'].to_i}"
      example.run
    end
  end

  config.after do |example|
    Allure.step name: example.metadata[:full_description]
    Allure.add_attachment(
      name: 'After example',
      source: @browser.screenshot.png,
      type: Allure::ContentType::PNG,
      test_case: true
    )
  end

  config.after :all do
    @browser.close

    env_file = FileWrite.new 'results/allure-results/environment.properties'
    browser = (ENV.fetch 'CI_BROWSER', BROWSER_NAME).gsub('_', ' ').capitalize

    env_file.write_allure_env browser: browser,
                              configuration: CONFIGURATION,
                              scope: @scope
  end
end

if ENV['CI_BROWSER']
  headless = Headless.new
  headless.start

  driver = Selenium::WebDriver.for ENV['CI_BROWSER'].downcase.to_sym

  puts # adds empty line for easier reading of console log
  puts "#{ENV['CI_BROWSER'].capitalize} headless browser started..."
  puts "Browser version is: #{driver.capabilities[:browser_version]}"
  puts # adds empty line for easier reading of console log

  at_exit do
    headless.destroy
  end
end
