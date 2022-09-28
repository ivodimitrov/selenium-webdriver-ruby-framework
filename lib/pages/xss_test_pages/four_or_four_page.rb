class FourOrFourPage < Base
  include PageObject

  text_field :query_text_field, id: 'query'
  button :search_button, id: 'button'
  link :try_again_link, xpath: '//a[contains(.,"Try again")]'

  def enter_query(query)
    working_payloads = []
    payloads = list_of_naughty_strings_or_payloads query

    payloads.each do |payload|
      begin
        query_text_field_element.set payload
        search_button
        browser.wait_until(timeout: 2) { browser.alert.present? }
      rescue Watir::Wait::TimeoutError
        try_again_link
      end

      while browser.alert.present?
        working_payloads << payload
        browser.alert.ok
        sleep 1
        try_again_link
      end

      sleep 1
    end

    print_payloads working_payloads
    working_payloads
  end
end
