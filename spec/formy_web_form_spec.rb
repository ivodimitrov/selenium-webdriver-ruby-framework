describe 'User' do
  before do
    @web_form_page = FormyWebFormPage.new(@browser).navigate_to
  end

  it 'complete web form' do
    thanks_page = @web_form_page.complete_web_form Faker::Name.first_name

    expect(thanks_page.alert_text).to eql(Constants::FORMY_SUCCESSFUL_ALERT_TEXT)
  end
end
