class FormyWebFormPage < Base
  def navigate_to
    @browser.goto Constants::FORMY_WEB_FORM_URL
    self
  end

  def complete_web_form(first_name)
    first_name_text_field.set first_name
    submit_button.scroll.to
    submit_button.click
    thanks_page = FormyThanksPage.new @browser
    Watir::Wait.until(timeout: 30) { thanks_page.loaded? }
    thanks_page
  end

  private

  def first_name_text_field
    @browser.text_field id: 'first-name'
  end

  def submit_button
    @browser.link(href: /thanks/)
  end
end
