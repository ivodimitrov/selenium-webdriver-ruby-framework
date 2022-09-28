require 'webdrivers'

namespace :localhost do
  %w(all bank costs_sales expense_reports regression smoke subscriptions).each do |suite|
    desc "Executes on localhost #{suite.gsub '_', ' '} tests"
    task suite do
      execute_tests environment: :localhost, suite: suite
    end
  end
end

namespace :production do
  %w(all bank costs_sales expense_reports regression smoke test).each do |suite|
    desc "Executes on production #{suite.gsub '_', ' '} tests"
    task suite do
      execute_tests environment: :production, suite: suite
    end
  end
end

namespace :staging do
  %w(all bank costs_sales expense_reports integrations regression smoke subscriptions test).each do |suite|
    desc "Executes on staging #{suite.gsub '_', ' '} tests"
    task suite do
      execute_tests environment: :staging, suite: suite
    end
  end
end

def execute_tests(environment:, suite:)
  browser = (ENV.fetch 'BROWSER', 'chrome').downcase

  case environment
  when :production
    environment_url = 'ENV_URL=...'
    config = 'CONFIG=production'
    environment_tag = 'prod'
  when :staging
    environment_url = 'ENV_URL=...'
    config = 'CONFIG=staging'
    environment_tag = 'stage'
  else
    environment_url = 'ENV_URL=http://localhost:3000'
    config = 'CONFIG=default'
    environment_tag = 'local'
  end

  command =
    "#{environment_url} #{config} bundle exec rspec spec/. --tag ~#{environment_tag}:false --tag ~#{browser}:false"

  case suite
  when 'all'
    exec command
  else
    exec "#{command} --tag #{suite}"
  end
end
