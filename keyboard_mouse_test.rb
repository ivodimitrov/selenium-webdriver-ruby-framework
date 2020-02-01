# load in the webdriver gem to interact with Selenium
require "selenium-webdriver"
require "chromedriver-helper"

# create a driver object
driver = Selenium::WebDriver.for:chrome
#maximize the window
driver.manage.window.maximize
# open Web Page 
driver.navigate.to "https://formy-project.herokuapp.com/keypress" 

# find the field for full name and send keys to that name field
name = driver.find_element(id: 'name')
name.send_keys('Examples of commonly actions that are automated in WebDriver test.')

# find the button called “button” and click it
button = driver.find_element(id: 'button')
# is the element visible on the page?
button.displayed?
button.click

puts driver.title

driver.quit