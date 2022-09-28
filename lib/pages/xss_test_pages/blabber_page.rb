class BlabberPage < Base
  include PageObject

  text_area :post_content_textarea, id: 'post-content'
  button :share_status_button, value: 'Share status!'
  button :clear_all_posts_button, value: 'Clear all posts'

  def post_content(content)
    working_payloads = []
    payloads = list_of_naughty_strings_or_payloads content

    payloads.each do |payload|
      begin
        post_content_textarea_element.set payload
        share_status_button
        browser.wait_until(timeout: 2) { browser.alert.present? }
      rescue Watir::Wait::TimeoutError
        clear_all_posts_button
      end

      while browser.alert.present?
        working_payloads << payload
        browser.alert.ok
        sleep 1
        clear_all_posts_button
      end

      sleep 1
    end

    print_payloads working_payloads
    working_payloads
  end
end
