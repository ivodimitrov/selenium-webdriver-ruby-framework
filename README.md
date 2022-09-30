### The project directory structure

```
root
  + config                        
     + data                       DataMagic folder for test data
  + lib
    + constants                   Constants
    + page_object                 Customizations for page object
    + pages                       Page-object classes
      + components                Components used in multiple pages (e.g. banners, tables, etc.)
    + steps                       Preconditions and/or multi-action test steps
  + resources                     Test resource files
  + results                       Test results
  + spec                          Test scenario implementations
    + xss_vulnerabilities         Test suite
    + spec_helper.rb              Rspec configuration
```

## Project setup

1. [Homebrew](https://brew.sh/) and [Bundler](https://bundler.io/) are required.
2. `config/data` folder is where different environments have their test data stored. Defaults can be changed on-demand.
3. Run the following step that installs the necessary dependencies:

```shell
bundle install
```

## Run configurations

Currently, the following environment variables are in use:

- `ENV_URL` defaults to `localhost:3000`. Any valid url (IP:PORT) can be passed to set the monolith target
  environment.

- `CONFIG` defaults to `default`. Available options are `default`, `staging` & `production`.
  This option controls which test data `.yml` file would be used by the test run.

- `BROWSER` defaults to `chrome`. Available options are `chrome`, `firefox` & `safari`. For example:
  `BROWSER=safari` or `BROWSER=firefox`. To use Safari, please read and follow steps
  from: [Watir Safari Guides](http://watir.com/guides/safari/).
  Headless mode is supported in Chrome & Firefox. You can turn on headless **locally** by passing the following:  
  `BROWSER=chrome_headless` or `BROWSER=firefox_headless`.

- `CI_BROWSER` is boolean, used as a mandatory option for **CI** builds. Available options are `CHROME` & `FIREFOX`.

- `WINDOW_SIZE` -> defaults to maximize browser window. Available for Chrome and Firefox. Safari has a known bug
  where resizing the browser window does not work as expected. You should specify a resolution to resize the browser
  window to a given width and height. For example: `WINDOW_SIZE=1280*740` or `WINDOW_SIZE=1280x740`.

## Executing the tests

### Rake tasks

List available tasks and their descriptions:

```shell
rake --tasks
```

- Execute subscriptions tests on staging:

```shell
bundle exec rake staging:task_name
```

### Executing tests on specific browser

Add environment variable `BROWSER` to existing rake tasks:

```shell
BROWSER=firefox bundle exec rake staging:task_name
```

### Executing specific spec

- Executes desired spec on localhost:

```shell
bundle exec rspec ./spec/path_to_spec/your_spec.rb
```

- Executes desired spec on staging:

```shell
ENV_URL=https://app.....dev/ CONFIG=staging bundle exec rspec ./spec/path_to_spec/your_spec.rb
```

- Executes desired spec on production:

```shell
ENV_URL=https://app.....com/ CONFIG=production bundle exec rspec ./spec/path_to_spec/your_spec.rb
```

### `--tag` option:

Use the `--tag` (or `-t`) option to run examples that match a specified tag.
The tag can be a simple `name` or a `name:value` pair.

You would specify `--tag` and the tag name (without the `:`) as a runtime parameter, like so:

```shell
bundle exec rspec --tag smoke
```

Alternatively, you can ignore tags with a `~` prepended to the tag name:

```shell
bundle exec rspec --tag ~smoke
```

To run just the `smoke` tag and negate the `local:false` tag, you would do the following:

```shell
bundle exec rspec --tag smoke --tag ~local:false
```

To run `smoke` tag and negate the `local:false` and `chrome:false` tags, you would do the following:

```shell
bundle exec rspec --tag smoke --tag ~local:false --tag ~chrome:false
```

### Executing specific test

Each individual test has TestRail ID as tag (symbol after test's name, which contains digits enclosed in
quotes: `tms:'12345'`)

- Execute desired test on localhost:

```shell
bundle exec rspec --tag tms:12345
```

- Executes desired test on staging:

```shell
ENV_URL=https://app.....dev/ CONFIG=staging bundle exec rspec --tag tms:12345
```

### Executing specific test from shared examples group

In order to execute shared examples you specify the path to the spec file, not to the shared examples file in
the `rspec` command (as usual).

```shell
bundle exec rspec ./spec/path_to_spec/your_spec.rb
```

In order to execute only one test from a shared examples group you have two options:

- Specify the name of the example with the `--example` option:

```shell
bundle exec rspec ./spec/path_to_spec/your_spec.rb --example name_of_the_scenario
```

Note: if you use interpolation in the scenario name substitute the interpolated variable with the proper string.

- Specify the TestRail ID with the `--tag` option:

```shell
bundle exec rspec ./spec/path_to_spec/your_spec.rb --tag tms:12345
```

### Run tests in parallel:

```shell
ENV_URL=https://app.....dev/ CONFIG=staging bundle exec parallel_rspec ./spec/path_to_spec/your_spec.rb
```

Make the first environment be 1:

```shell
ENV_URL=https://app.....dev/ CONFIG=staging bundle exec parallel_rspec --first-is-1 ./spec/path_to_spec/your_spec.rb
```

Specify how many processes to use, default: available CPUs:

```shell
ENV_URL=https://app.....dev/ CONFIG=staging bundle exec parallel_rspec -n 2 ./spec/path_to_spec/your_spec.rb
```

For more info, please visit: [Parallel gem documentation](https://github.com/grosser/parallel)

## Test results

The test results will be recorded in the `results` directory.

To generate the report from existing Allure results you can use the following command:

```shell
allure generate results/allure-results --clean -o allure-report
```

Open it in your default system browser, run:

```shell
allure open allure-report
```

For more info, please visit:
[Allure Framework official documentation](https://docs.qameta.io/allure-report)

## Tips and tricks

Usage of [watir-scroll](https://github.com/titusfortner/watir-scroll)

## Grouping tests together

[Slice and dice tests with tags](https://elementalselenium.com/tips/58-tagging)

## Define helper methods in a module

You can define helper methods in a module and include it in your example
groups using the config.include configuration option.
File named `xyz_steps.rb` could be added to `./lib/steps/` with:

```ruby

module XYZSteps
  def help
    :available
  end
end
```

At `spec_helper.rb` update `RSpec.configure do |config|` with:

`config.include XYZSteps`

The [RSpec docs](https://relishapp.com/rspec/) for helper methods can be found at
[Define helper methods in a module](https://relishapp.com/rspec/rspec-core/v/3-11/docs/helper-methods/define-helper-methods-in-a-module)

## Defining element collections using the Page Object gem

[Defining element collections using the page objects gem](https://jkotests.wordpress.com/2013/06/24/defining-element-collections-using-the-page-objects-gem/)

[Plural form of element using page-object gem](https://stackoverflow.com/questions/39512014/plural-form-of-element-using-page-object-gem/39512303#39512303)

[Watir, Page-objects: how to get all elements that have the same identifier](https://stackoverflow.com/questions/17276695/watir-page-objects-how-to-get-all-elements-that-have-the-same-identifier/17277283#17277283)

[Looping through a collection of divs in Watir](https://stackoverflow.com/questions/17306534/looping-through-a-collection-of-divs-in-watir/17307367#17307367)

Watir can find and return an:

Element - The first (single) matching element or

Element Collection - All matching elements.

There are two element type methods, for each supported element, that correlate to the return type:

Singular - This version returns the element.

Plural - This version returns the element collection.

For example, the div method, which is singular, will tell Watir to find the first div element on the page:
`browser.div`

The pluralization of div is divs, which will return all div elements on the page:
`browser.divs`

Note that the pluralized version is generally the singular version with an ‘s’ added to the end. However, following
English conventions, there will be some element types that have ‘es’ added to the end or have the ending ‘y’ replaced by
‘ies’.

Source: [Book: Watirways](https://leanpub.com/watirways)

Interacting with elements on the page (xyz_page):

```ruby
xyz_element.present?
xyz_element.exists?
xyz_element.selected?
xyz_element.enabled?
xyz_element.text # If element has text.
xyz_element.attribute('attribute')
```

Interacting with browser on the page (xyz_page):

```ruby
@browser.refresh
@browser.url
@browser.title
@browser.text
```

Interacting with elements in the spec (xyz_spec):

```ruby
on(XyzPage).xyz_element.present?
on(XyzPage).xyz_element.exists?
on(XyzPage).xyz_element.selected?
on(XyzPage).xyz_element.enabled?
on(XyzPage).xyz_element.text
```

Interacting with current page in the spec (xyz_spec):

```ruby
@current_page.url
@current_page.title
@current_page.text
@current_page.refresh
@current_page.text.include? 'text' # Return true if the specified text appears on the page
```

## Watir Webdriver Cheatsheet

### Browser

```ruby
# start new driver session
@browser = Watir::Browser.new :firefox
@browser = Watir::Browser.new :chrome
@browser = Watir::Browser.new :ie

# goto url
@browser.goto "https://labs.com"

# refresh
@browser.refresh
# close
@browser.quit
```

### Text field

```ruby
# enter value
@browser.text_field(:id => "text").set "watir-webdriver"

# get value
@browser.text_field(:id => "text").value

# clear
@browser.text_field(:id => "text").clear
```

### Button

```ruby
# is enabled?
@browser.button(:id => "btn").enabled?

# button's text
@browser.button(:id => "btn").text

# click
@browser.button(:id => "btn").click
```

### Checkbox

```ruby
# check
@browser.checkbox(:id => "btn").set
@browser.checkbox(:id => "btn").set(true)

# uncheck
@browser.checkbox(:id => "btn").clear
@browser.checkbox(:id => "btn").set(false)

# is checked?
@browser.checkbox(:id => "btn").set?
```

### Listbox

```ruby
# select from list text
@browser.select_list(:id => "list").select "var"

# select using value
@browser.select_list(:id => "list").select_value "var2"

# value is selected?
@browser.select_list(:id => "list").selected?("var2")

# get value
puts @browser.select_list(:id => "list").value

# get all items
@browser.select_list(:id => "list").options.each do |i|
  puts "#{i.text}"
end
```

### Radio

```ruby
# select value
@browser.radio(:id => "radio").set

# is var selected?
@browser.radio(:id => "radio").set?
```

### Image

```ruby
# is image loaded?
@browser.image(:src => "img.gif").loaded?

# height
@browser.image(:src => "img.gif").height

# width
@browser.image(:src => "img.gif").width

# click
@browser.image(:src => "img.gif").click

# click 1st image
@browser.images[0].click
```

### Div

```ruby
# get text
@browser.div(:class => "body").text

# get text of 2nd div when it appears
@browser.divs[1].when_present.text
```

### Table

```ruby
# row 1, col 1
@browser.table(:id => "table")[0][0].text

# row 1, col 2 (alternate)
@browser.table(:id => "table").tr { 0 }.cell { 1 }.text

# row 2 - entire text
puts @browser.table(:id => "table")[1].text

# click row #4
puts @browser.table(:id => "table")[3].click

# get column count
@browser.table(:id => "table").row.cells.length

# row count
@browser.table(:id => "table").row_count
@browser.table(:id => "table").rows.length
```

### General

```ruby
# [exists?]
@browser.text_field(:id => "text").exists?

# [enabled?]
@browser.select_list(:id => "list").enabled?

# [present?]
@browser.element(:id => "e").present?

# [tag_name]
@browser.element(:id => "e").tag_name

# [screenshot]
@browser.screenshot.save "c:\\page.png"

# [to_subtype] # returns button
@browser.element(:id => "btn").to_subtype

# [index] click 2nd image on page
@browser.image(:index => 1).click

# [loops]
# get names of all text-fields
@browser.text_fields.each do |i|
  puts i.name
end

# get name of first text-field
puts @browser.text_fields[0].name

# get name of second text-field
puts @browser.text_fields[1].name
```

### Waiting

```ruby
# [wait_until_present]
@browser.button(:id => "btn").when_until_present

# [when_present]
@browser.button(:id => "btn").when_present.click
@browser.button(:id => "btn").when_present(10).click

# [wait_while_present]
@browser.button(:value => "submit").click
@browser.button(:value => "submit").wait_while_present

# [implicit wait] 5 seconds
# good to have, but i don't recommend its global use
@browser.driver.manage.timeouts.implicit_wait = 5
```

## Shared Examples

Whenever there are tests that are absolutely the same but have to be executed from different places (e.g. tests related
to same functionality for costs and sales) we can take advantage of RSpec’s shared examples functionality (documentation
can be found [here](https://relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples)).

### Creation and usage

When you create shared examples, you can put them in the `spec/shared_examples` folder. The files have to be with `.rb`
extension and should **NOT** have `_spec` in the end of their name. A file should look like this:

```ruby
shared_examples 'meaningful name of the shared examples group' do |parameters_if_needed|
  before do
    you_can_put_hooks_if_needed
  end

  it 'scenario one' do
    scenario_code
  end

  it 'scenario_two' do
    scenario_code
  end
end
```

Then, in the spec file you can include the examples with the include_examples method:

```ruby
describe "Some tests" do
  some_code

  include_examples 'name_of_the_shared_examples_group'
end
```

### Note on adding TestRail IDs

We would like to keep adding TestRail IDs in all executed tests. With that in mind, when creating shared examples, it
would be good to always have at least one parameter - tms. A shared example file will then look like this:

```ruby
shared_examples 'name of examples' do |tms|
  it "name of test", tms: tms do
    test_code
  end
end
```

When using the shared example you then pass on the parameter as follows:

```ruby
include_examples 'name of examples', '23336'
```

When the shared examples group contains multiple tests, you can make a tmses parameter and when calling the examples to
put an array of tms numbers as an argument:

```ruby
shared_examples 'shared examples group' do |tmses|
  it "test one", tms: tmses[0] do
    test_code
  end

  it "test two", tms: tmses[1] do
    test_code
  end
end
```

The invocation will then look like this:

```ruby
include_examples 'shared examples group', %w(12345 12346 12347)
```

### Executing shared examples locally

In order to execute shared examples you specify the path to the spec file, not to the shared examples file in the rspec
command (as usual).

```shell
bundle exec rspec ./spec/path_to_spec/your_spec.rb
```

In order to execute only one test from a shared examples group you have two options.

1. Specify the name of the example with the `--example` option

```shell
bundle exec rspec ./spec/path_to_spec/your_spec.rb --example name_of_the_scenario
```

Note: if you use interpolation in the scenario name substitute the interpolated variable with the proper string.

2. Specify the TestRail ID with the `--tag` option

```shell
bundle exec rspec ./spec/path_to_spec/your_spec.rb --tag tms:12345
```
