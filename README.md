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
bundle exec rake staging:subscriptions
```

### Executing tests on specific browser

Add environment variable `BROWSER` to existing rake tasks:

```shell
BROWSER=firefox bundle exec rake staging:subscriptions
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

:warning: **This is experimental feature!** Works with `subscriptions` and probably with `integrations` spec!

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
