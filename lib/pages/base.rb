class Base
  DEFAULT_TIMEOUT = 15

  # Method will wait text to present. Method also will rescue and reraise Timeout exception if occur
  # and print the text, which is not present.
  def wait_text_present(text, timeout: DEFAULT_TIMEOUT, regexp: false)
    browser.wait_until timeout: timeout do |browser|
      regexp ? browser.text.match?(text) : browser.text.include?(text)
    end
  rescue Watir::Wait::TimeoutError
    raise Watir::Wait::TimeoutError, "Failure/Error: The following text: '#{text}' was not present!"
  end

  # The method will wait for the text to disappear. The method will also rescue and reraise a Timeout exception if
  # it occurs and print the text which does not disappear.
  def wait_text_disappear(text, timeout: DEFAULT_TIMEOUT)
    browser.wait_while timeout: timeout do |browser|
      browser.text.include? text
    end
  rescue Watir::Wait::TimeoutError
    raise Watir::Wait::TimeoutError, "Failure/Error: The following text: '#{text}' did not disappear!"
  end

  # Refreshes browser's page every three seconds and waits for a certain text to be present.
  # Default waiting time is 180 seconds.
  def refresh_page_until_text_present(text:, times: 60)
    count = 0
    sleep 1
    until (@browser.text.include? text) || count >= times
      @browser.refresh
      sleep 3
      count += 1
    end
    raise "Failure/Error: The following text: '#{text}' was not present!" if count == times
  end

  # Refreshes browser's page every second and waits for a certain element to be present.
  def refresh_page_until_element_present(element, times: 60)
    count = 0
    sleep 1
    until element.present? || count >= times
      @browser.refresh
      sleep 1
      count += 1
    end
    raise "Failure/Error: The following element: '#{element}' was not present!" if count == times
  end

  # Refreshes the browser's page every three seconds and waits for a certain text to disappear.
  # Default waiting time is 180 seconds.
  def refresh_page_until_text_disappear(text:, times: 60)
    count = 0
    sleep 1 # pls keep this sleep!
    while (@browser.text.include? text) && count < times
      @browser.refresh
      sleep 3
      count += 1
    end
    raise "Failure/Error: The following text: '#{text}' did not disappear!" if count == times
  end

  def wait_element_disappear(element, timeout: DEFAULT_TIMEOUT)
    element.wait_while(timeout: timeout, &:present?)
  rescue Watir::Wait::TimeoutError
    raise Watir::Wait::TimeoutError, "Failure/Error: The following element: '#{element.text}' did not disappear!"
  end

  def wait_element_present(element, timeout: DEFAULT_TIMEOUT)
    element.wait_until(timeout, &:present?)
  end

  def wait_element_present_and_get_text(element, timeout: DEFAULT_TIMEOUT)
    element.wait_until(timeout, &:present?).text
  end

  def wait_element_present_and_click_it(element, timeout: DEFAULT_TIMEOUT)
    element.wait_until(timeout, &:present?).click
  end

  def wait_element_to_be_enabled_and_click_it(element, timeout: DEFAULT_TIMEOUT)
    element.wait_until(timeout, &:enabled?).click
  end

  def wait_selection_saved_for(element, timeout: DEFAULT_TIMEOUT)
    element.wait_until(timeout) { |el| el.class_name.include?('automatic-done') || el.class_name.include?('success') }
  end

  def clear_text_field(element)
    sleep 1
    while element.value != ''
      element.send_keys :arrow_down
      element.send_keys :backspace
      sleep 0.1
    end
    sleep 1
  end

  def self.build_url(endpoint)
    test_url = ENV.fetch 'ENV_URL', 'http://localhost:3000'
    test_url + endpoint
  end

  def confirm_alert
    if browser.alert.present?
      browser.alert.ok
      puts 'Alert was present and confirmed!'
    else
      puts 'Alert was not present!'
    end
  end

  def scroll_to_element(element)
    element.scroll.to
    sleep 1
  end

  def scroll_to_element_and_click(element)
    scroll_to_element element
    wait_element_present_and_click_it element
  end

  def press_tab
    @browser.send_keys :tab
    sleep 1
  end

  def press_escape
    @browser.send_keys :escape
  end

  def navigate_to_url(url)
    browser.goto url
    browser.wait_until(timeout: 10) { browser.url == url }
  end

  def initialize(browser)
    @browser = browser
  end

  def list_of_naughty_strings_or_payloads(strings_or_payloads)
    case strings_or_payloads
    when :payloads_from_constant
      XSSConstants::PAYLOADS
    when :naughty_strings
      read_from_file './resources/naughty_strings.txt'
    when :payloads
      read_from_file './resources/xss_payload_list.txt'
    else
      raise ArgumentError, "Expected: :naughty_strings, :payloads_from_constant or :payloads,
                            got: #{strings_or_payloads}"
    end
  end

  def read_from_file(file_name)
    payloads = []
    File.readlines(file_name, chomp: true).drop(2).each do |line|
      payloads << line
    end
    payloads
  end

  # Method will print the succeed payloads on terminal.
  def print_payloads(payloads)
    payloads.each do |payload|
      puts "[ERROR] Exploit found! Payload: #{payload}"
    end
  end
end
