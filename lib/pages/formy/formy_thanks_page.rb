class FormyThanksPage < Base
  # Verify Formy Thanks Page is loaded by URL.
  def loaded?
    @browser.wait_until(timeout: 10) { @browser.url == Constants::FORMY_THANKS_PAGE_URL }
  end

  def alert_text
    @browser.wait_until { alert_success.present? }
    alert_success.text
  end

  private

  def alert_success
    @browser.element css: '.alert.alert-success'
  end
end
