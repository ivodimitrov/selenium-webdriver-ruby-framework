require "selenium-webdriver"
require "chromedriver-helper"

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://formy-project.herokuapp.com/autocomplete"

autocomplete = driver.find_element(id: 'autocomplete')
autocomplete.send_keys('1555 park blvd, palo alto, ca, usa')

# implicit
# driver.manage.timeouts.implicit_wait = 5

# explicit
wait = Selenium::WebDriver::Wait.new(timeout: 5)
wait.until { driver.find_element(class: 'pac-item').displayed? }

autocomplete_result = driver.find_element(class: 'pac-item')
autocomplete_result.click

driver.quit
