class Constants
  # Global
  CONFIGURATION = ENV.fetch 'CONFIG', 'default'

  def self.build_data
    DataMagic.load "#{CONFIGURATION}.yml"
  end

  # Accounts credentials
  PARTNER_EMAIL = build_data['login']['partner_email']
  PASSWORD = build_data['login']['password']

  FORMY_WEB_FORM_URL = 'https://formy-project.herokuapp.com/form'.freeze

  FORMY_THANKS_PAGE_URL = 'https://formy-project.herokuapp.com/thanks'.freeze
  FORMY_SUCCESSFUL_ALERT_TEXT = 'The form was successfully submitted!'.freeze

  THE_INTERNET_URL = 'https://the-internet.herokuapp.com/'.freeze
  THE_INTERNET_LOGIN_PAGE_URL = 'https://the-internet.herokuapp.com/login'.freeze
end
