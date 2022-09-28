# require 'faker'
# require 'rspec'
# require 'watir'
# require 'webdrivers'

describe 'User' do
  before do
    # By default Watir will open a Chrome Browser. To open other browsers,
    # specify the one you want as the first argument:
    # Watir::Browser.new :firefox
    # Watir::Browser.new :safari

    # Initialize the Browser
    # @browser = Watir::Browser.new
    # Navigate to Page
    @browser.goto Constants::FORMY_WEB_FORM_URL
    @first_name = @browser.text_field id: 'first-name'
    @last_name = @browser.text_field id: 'last-name'
    @submit_button = @browser.link href: '/thanks'
    @alert = @browser.div css: '.alert-success'
  end

  # after do
  #   @browser.close
  # end

  it 'complete web form only with first name' do
    @first_name.set Faker::Name.name
    @submit_button.scroll.to
    @submit_button.click
    alert_text = @alert.text

    expect(alert_text).to eq Constants::FORMY_SUCCESSFUL_ALERT_TEXT
  end

  it 'complete web form with first and last name' do
    @first_name.set Faker::Name.first_name
    @last_name.set Faker::Name.last_name
    @submit_button.scroll.to
    @submit_button.click
    alert_text = @alert.text

    expect(alert_text).to eq Constants::FORMY_SUCCESSFUL_ALERT_TEXT
  end
end
