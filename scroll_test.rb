require "selenium-webdriver"
require "chromedriver-helper"

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://formy-project.herokuapp.com/scroll"

name = driver.find_element(id: 'name')
driver.action.move_to(name).perform
name.send_keys('Automate an example of scrolling an element into view')

date = driver.find_element(id: 'date')
date.send_keys('01/01/2021')

driver.quit